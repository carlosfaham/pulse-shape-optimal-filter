%% Generate template, signal and noise

% Time vector
tt = 0:0.1:100;
% Amplitude "truth" value
A_original = 5;

% Make a template with a doulbe exponential "pulse"
ampli = 1;
tfall = 1.5;
offset = 3;
trise = 3;

out = -(exp(-(tt-offset)./tfall) - exp(-(tt-offset)./trise));
out(tt<offset) = 0;

% Normalize
template = out / max(out(isfinite(out)))

% Add some noise
noise = randn(length(tt),100)*1.5;

% Scale
p = A_original.*circshift(template,[1 400])' + noise(:,1);

[A,delay,ftraces] = OptimalFilter(template,p,noise);

%% Plot it

figure(432); clf
subplot(3,1,1); hold on
plot(tt,template,'k-')
ylim([-0.1 1.2])
xlim([0 100])
legend('Template s(t)')

subplot(3,1,2:3); hold on
plot(tt,p,'k-')
plot(tt,ftraces,'b--','linew',1.2)
[maxval,maxind] = max(ftraces);
plot(tt(maxind),maxval,'bo','markers',10,'handlev','off')
plot([1 1]*tt(maxind),[-5 17],'b--')
plot(tt+tt(delay),template.*A,'r-','linew',1.2,'handlev','off')
xlabel('Time')

legend(sprintf('p(t) = A s(t) + n(t)\n(A = 5, n_\\sigma = 3)'),'Filter output: [\phi(t)*s(t)]',sprintf('Best estimate for A = %1.2f',A));
ylim([-5 17])
xlim([0 100])
set(gca,'YTick',-5:5:15)
