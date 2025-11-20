% --- Setup ---
dq = daq("ni");
addinput(dq, "Dev1", "ai0", "Voltage");
addinput(dq, "Dev1", "ai1", "Voltage");
addinput(dq, "Dev1", "ai2", "Voltage");
dq.Rate = 100;  % samples per second

% --- Create Figure with Subplots ---
figure;

subplot(3,1,1);  % first subplot
h0 = animatedline('Color','r','LineWidth',1.5);
title('ai0 Pressure');
xlabel('Time (s)');
ylabel('Pressure (units)');
grid on;

subplot(3,1,2);  % second subplot
h1 = animatedline('Color','g','LineWidth',1.5);
title('ai1 Pressure');
xlabel('Time (s)');
ylabel('Pressure (units)');
grid on;

subplot(3,1,3);  % third subplot
h2 = animatedline('Color','b','LineWidth',1.5);
title('ai2 Pressure');
xlabel('Time (s)');
ylabel('Pressure (units)');
grid on;

% --- Start Timer ---
startTime = datetime('now');

% --- Continuous Loop ---
while ishandle(h0)
    % Read 0.1 seconds of data
    data = read(dq, seconds(0.1));
    
    % Convert voltage to pressure
    pressureData = data{:,:} * 8.8348 * 100;

    % Get elapsed time for each sample (a vector)
    numSamples = height(data);
    t = seconds(datetime('now') - startTime) + (0:numSamples-1)'/dq.Rate;

    % Add all samples at once (pressure instead of voltage)
    addpoints(h0, t, pressureData(:,1));
    addpoints(h1, t, pressureData(:,2));
    addpoints(h2, t, pressureData(:,3));
    
    drawnow limitrate;
end

