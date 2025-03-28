%% PPS Individual Analysis
close all; clear; clc;

file_to_load = 'P07_TrialData20250328125304.csv'; % Ensure file is in the folder
output_file = 'PPS_data.xlsx'; % Output Excel file
sheet_name = 'Sheet1'; % Sheet name

% Read CSV file into a table
data_raw = readtable(file_to_load, 'TextType', 'string'); % Ensures text data stays as strings

part_ID = input("Participant ID # : ");

% Extract relevant columns
trial_type_col = data_raw.TrialType; % Assuming column 2 header is 'TrialType'
tactordelay_col = data_raw.TactorDelay; % Assuming column 5 header is 'TactorDelay'
reaction_time_col = data_raw.RT; % Assuming column 8 header is 'RT'

% Split data based on trial type
visual_data = data_raw(ismember(trial_type_col, ["Visual", "VisualCatch"]), :);
tactile_data = data_raw(trial_type_col == "Tactile", :);
visuotactile_data = data_raw(trial_type_col == "VisuoTactile", :);

% Find unique tactor delay values from tactile_data
unique_tactordelays = unique(tactile_data.TactorDelay); 

% Initialize meanRT_values (2 x number of unique delays)
meanRT_values = zeros(2, length(unique_tactordelays));

% Compute mean RT for each tactor delay
for i = 1:length(unique_tactordelays)
    delay_value = unique_tactordelays(i);

    % Mean RT for Tactile trials with this delay
    meanRT_values(1, i) = mean(tactile_data.RT(tactile_data.TactorDelay == delay_value), 'omitnan');

    % Mean RT for VisuoTactile trials with this delay
    meanRT_values(2, i) = mean(visuotactile_data.RT(visuotactile_data.TactorDelay == delay_value), 'omitnan');
end

%% **Third Plot: Fit a Sigmoid to VisuoTactile Mean RT Values**
figure;
scatter(unique_tactordelays, meanRT_values(2, :), 'bo', 'filled'); % Plot raw data points
hold on;

% Ensure column vectors for fitting
xdata = unique_tactordelays(:);  % Convert to column vector
ydata = meanRT_values(2, :)';  % Convert to column vector

% Sigmoidal function definition
sigmoid = @(p, x) p(1) ./ (1 + exp(-p(2) * (x - p(3)))); % a / (1 + exp(-b(x-c)))

% Initial parameter estimates: [max RT, slope, inflection point]
p0 = [max(ydata), 1, mean(xdata)];

% Fit sigmoid to VisuoTactile mean RT values
opts = optimset('Display', 'off'); % Suppress fitting messages
p_fit = lsqcurvefit(sigmoid, p0, xdata, ydata, [], [], opts);

% Compute fitted values
fitted_values = sigmoid(p_fit, xdata);

% Plot sigmoid fit
plot(xdata, fitted_values, '-r', 'LineWidth', 2);

% Compute and mark centroid (inflection point)
PPS_centroid = [p_fit(3), sigmoid(p_fit, p_fit(3))];
plot(PPS_centroid(1), PPS_centroid(2), 'ks', 'MarkerSize', 10, 'MarkerFaceColor', 'k');

hold off;

% Formatting
xlabel('Tactor Delay (s)');
ylabel('Mean RT (VisuoTactile Condition)');
title('Sigmoidal Fit of VisuoTactile Mean RT vs. Tactor Delay');
legend({'Raw Data', 'Sigmoid Fit', 'Centroid (Inflection Point)'}, 'Location', 'Best');
grid on;

% Compute slope at the centroid
a_fit = p_fit(1); % Amplitude parameter from sigmoid fit
b_fit = p_fit(2); % Slope parameter from sigmoid fit
c_fit = p_fit(3); % Centroid (inflection point)

% Compute slope at centroid (x = c)
slope_at_centroid = (a_fit * b_fit) / 4;

%% **Check for Duplicate Row Before Appending**
% Read existing data to find where to append the row
if isfile(output_file)
    existing_data = readtable(output_file, 'Sheet', sheet_name);
    next_row = height(existing_data) + 1; % Find next available row
else
    existing_data = [];
    next_row = 2; % Start on second row if file is new
end

% Create a structured row matching header order
data_row = [part_ID, meanRT_values(1, :), meanRT_values(2, :), PPS_centroid(1), slope_at_centroid];

% Convert to table format matching existing headers
data_table = array2table(data_row, 'VariableNames', existing_data.Properties.VariableNames);

% **Check if the row already exists in the Excel file**
if ~isempty(existing_data)
    % Convert both existing and new row to string format for comparison
    existing_values = table2cell(existing_data);
    new_row_values = table2cell(data_table);

    % Check for exact row match
    duplicate_found = any(cellfun(@(row) isequal(row, new_row_values), num2cell(existing_values, 2)));

    if duplicate_found
        error('This data already exists in the Excel sheet! No new row was added.');
    end
end

% Append data to Excel
writetable(data_table, output_file, 'Sheet', sheet_name, 'WriteMode', 'Append', 'WriteVariableNames', false);

disp(['Data successfully appended to ', output_file]);
