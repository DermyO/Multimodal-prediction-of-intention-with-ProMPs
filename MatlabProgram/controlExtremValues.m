function posterior = controlExtremValues(posterior,s_bar)

%% the goal of this function is to verify that the value of the matrix is in the range givent varargin.

clicks = posterior(1:s_bar);
clicks(clicks < 0) = 0;
scores = posterior(s_bar+1:s_bar*2);
scores(scores > 100) = 100;
scores(scores < 0) = 0;
delays = posterior(s_bar*2+1:s_bar*3);
delays(delays >240) = 240;
delays(delays <-240)= -240;
posterior = [clicks;scores;delays];

