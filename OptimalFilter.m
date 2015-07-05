function [A delay ftraces] = OptimalFilter(template,traces,noise)
% [A delay ftraces] = OptimalFilter(template,traces,noise)
%
% This function takes an idealized pulse template, mutliple real-world noisy time-series, 
% and noise-only time-series, and it outputs the best amplitude estimator for the template
% as applied to each time-series trace.
%
% See file example.m to see a visual example.
%
% Inputs:
%   template - a time vector containing a template to be matched in the traces input
%     traces - a matrix with rows corresponding to time-series measurements of a signal+noise 
%               and columns corresponding to each measurement
%      noise - similar to traces above, but only containing noise. This is used to measure the noise power spectrum.
%
% Outputs:
%       A - the amplitude estimator vector, corresponding to the number of traces in the input
%   delay - the time shift for the template matched for each trace
% ftraces - the filter output (template convolved with each time-series trace)
%
% CH Faham

%% Check inputs
[a b] = size(template);

if a~= 1 && b~=1
    error('template must be vector')
elseif a == 1
    template = template';
end
    
N = length(template);

if size(traces,1) ~= N
    traces = traces';
end

if size(noise,1) ~= N
    noise = noise';
end

M = size(traces,2);

j = sqrt(-1); % make sure imaginary unit is defined

%% Compute filter
samplerate = 1;
t = 0:(N-1);
fnoise = mean(fp_optfilt(noise),2);
filt = conj(ff_optfilt(template))./fnoise;

phase_factor = zeros(N,M);
Atop = zeros(1,M);
Abottom = sum(real(ff_optfilt(template) .* filt));

ftraces = real( fi_optfilt(  repmat(filt,1,M) .* ff_optfilt(traces,1) ) );
[a delay] = max(ftraces);% + maxoffset; %index for t where pulse max resides
phase_factor = exp(2*pi*j      * repmat(t',1,M)/N .* repmat(delay,N,1));   
Atop    = sum(real(ff_optfilt(traces,1)  .* phase_factor .* repmat(filt,1,M))) / sqrt(samplerate);

A = Atop./Abottom;

function [out] = fp_optfilt(in)
% fp(in) is power in fft: abs(ff(in)).^2
temp = ff_optfilt( in );
out = abs(temp).^2;

function [out] = fi_optfilt(in)
% fi(in) is the inverse FFT that corresponds to the function ff()
% and so it obeys Parseval's Theorem
out = conj(ff_optfilt(conj(in)));	

function [out] = ff_optfilt(in,dim)
% ff(in) is 1/sqrt(length(in)) * fft(in)
% and so it obeys Parseval's Theorem
if nargin < 2
    out = fft(in)./sqrt(length(in));
else
    out = fft(in)./sqrt(size(in,dim));
end
