% --- Setup ---
dq = daq("ni");
addinput(dq, "Dev1", "ai0", "Voltage");
addinput(dq, "Dev1", "ai1", "Voltage");
addinput(dq, "Dev1", "ai2", "Voltage");
dq.Rate = 100;  % samples per second

% --- Create Figure ---
figure;
h0 = animatedline('Color','r','LineWidth',1.5);
h1 = animatedline('Color','g','LineWidth',1.5);
h2 = animatedline('Color','b','LineWidth',1.5);
legend({'ai0','ai1','ai2'});
title('Live Voltage Readings (ai0–ai2)');
xlabel('Time (s)');
ylabel('Voltage (V)');
grid on;

% --- Start Timer ---
startTime = datetime('now');

% --- Continuous Loop ---
while ishandle(h0)
    % Read 0.1 seconds of data
    data = read(dq, seconds(0.1));

    % Get elapsed time for each sample (a vector)
    numSamples = height(data);
    t = seconds(datetime('now') - startTime) + (0:numSamples-1)'/dq.Rate;

    % Add all samples at once
    addpoints(h0, t, data{:,1});
    addpoints(h1, t, data{:,2});
    addpoints(h2, t, data{:,3});

    drawnow limitrate;
end
