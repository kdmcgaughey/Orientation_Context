
% Make fake impulse response function with Gamma function (gammapdf)

fake_IRF = gampdf(1:100,10,3);

figure
plot((1:100)/100,fake_IRF)

%%

% Make fake random walk signal with SD = 3 (likely experimental condition)
% 100 "trials"

for i = 1:100

    % Random walk:

    stim_RW = normrnd(0, 5, [1,1500]);
    stim_RW = cumsum(stim_RW);

    all_stim_RW(i,:) = stim_RW;

    % Sinusoid:

%     f = 1/120;
%     p = 120;
%     a = 8;
%     t = 1:1:1500;
%     %y = a*sin(2*pi*f*t);
%     y = a*sin(mod(t,p)*(2*pi/p));
    
    all_stim_SW(i,:) = y;

end

%%

figure

plot(all_stim_RW(1,:))
hold on;
% plot(all_stim_SW(1,:))


% Combine

%all_stim = all_stim_RW + all_stim_SW;
all_stim = all_stim_RW;

%%

% Pad IRF to center peak within the array

IRF_pad = [zeros(1,32), fake_IRF];

% Convolve IRF with signal

for t = 1:size(all_stim,1)
    %resp(t,:) = conv(all_stim(t,:), flip(fake_IRF), 'same');
    %resp(t,:) = conv(flip(IRF_pad), all_stim(t,:), 'same');
    resp(t,:) = conv(all_stim(t,:), fake_IRF, 'full');

end

% Plot stuff

figure

plot(all_stim(1,:))
hold on;
plot(resp(1,1:1500))

%%

% Take difference 

stim_diff = diff(all_stim,1,2);
resp_diff = diff(resp,1,2);

% Cross correlate

smpVal = 1:1:size(stim_diff,2);     % Values at which time series are sampled
maxLagVal = 120;                    % Maximum lag (in units of smpVal)
bPLOT = 0;                          % Plot or not
bPLOTall = 0;                       % Plot or not   


for t = 1:size(all_stim,1)
   
    [r, lags] = xcorrEasy(stim_diff(t,:)',resp_diff(t,:)', smpVal', maxLagVal, 'coeff', [], bPLOT, bPLOTall);

    all_r(t,:) = r;
    all_lags(t,:) = lags;
end

%%

% Average cross correlation

avg_xcorr_5 = mean(all_r,1);
avg_lag_5 = mean(all_lags,1);

% Plot stuff

figure
plot(avg_lag_5/60,avg_xcorr_5)
xlim([0 1])


