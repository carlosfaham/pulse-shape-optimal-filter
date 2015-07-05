# pulse-shape-optimal-filter
Optimal Filter for matching a template to noisy data in Matlab

See Sunil Golwala's Berkeley PhD thesis for more information about Optimal Filters:
http://cosmology.berkeley.edu/preprints/cdms/golwalathesis/thesis_app.pdf

Optimal filter matching is very useful when the underlying time profile ("template") of data is known and we want to estimate the best template match on the data.

OptimalFilter.m will perform the optimal filter match from an idealized template to noisy time-series data. 
It outputs the best time-delay and amplitude estimators for the template matching.

Please look at the provided example.m for a working example and generated plot.

