%% PPS Group Analysis
close all; clear; clc;

% Step 1 - ensure excel file (named 'PPS_data') is closed and in same folder as this script
%
% Step 2 - hit run at the top left of the matlab window
% 
% Step 3 - specify what types of plots you want into the command window and then hit enter
%
% Step 4 - plot any variable combination you want by copying the lines of codes, pasting them right under where you copied from,s and then just changing the x and y information!!!

single_group_scatters = input('Plot Single Group Scatters? 0 = NO; 1 = YES : ');
single_group_regressions = input('Plot Single Group Regressions? 0 = NO; 1 = YES : ');

%% Figure variables to keep uniform throughout
scatter_size = 500;
color1 = '#c51b7d'; color2 = '#4d9221'; color3 = '#01665e';
icon1 = 'o'; icon2 = '^'; icon3 = 's';
figure_font_size = 24; single_group = 1;

dataAll = readtable('PPS_data.xlsx',  'Sheet', 'Sheet1');

D1_tactile = table2array(dataAll(:, 2));
D2_tactile = table2array(dataAll(:, 3));
D3_tactile = table2array(dataAll(:, 4));
D4_tactile = table2array(dataAll(:, 5));
D5_tactile = table2array(dataAll(:, 6));
D6_tactile = table2array(dataAll(:, 7));
D1_visuotactile = table2array(dataAll(:, 8));
D2_visualtactile = table2array(dataAll(:, 9));
D3_visualtactile = table2array(dataAll(:, 10));
D4_visualtactile = table2array(dataAll(:, 11));
D5_visualtactile = table2array(dataAll(:, 12));
D6_visualtactile = table2array(dataAll(:, 13));
PPS_size = table2array(dataAll(:, 14)); % in seconds, centroid x value
PPS_gradient = table2array(dataAll(:, 15)); % in seconds/seconds???, centroid slope
% put other variables you want to analyze here from excel sheet, like
% questionnairre scores

if single_group_scatters
    % --- Plot 1: ??? vs ??? ---
    x_name = 'put x label here';
    y_name = 'put y label here';
    
    PPS_scatter_plotter(PPS_size, PPS_gradient, icon1, color1, figure_font_size, scatter_size, x_name, y_name, single_group);
    PPS_delta_histogram_plotter(PPS_size, PPS_gradient, color1, figure_font_size, x_name, y_name, single_group);
end

if single_group_regressions
    % --- Plot 13a: Linear Regression Vis Weight vs Cue Aud ---
    x_name = 'put x label here';
    y_name = 'put y label here';
    x_lim = [0 2]; x_ticks = [0 0.4 0.8 1.2 1.6 2.0]; % x axis info
    y_lim = [0 2]; y_ticks = [0 0.4 0.8 1.2 1.6 2.0]; % y axis info
    
    PPS_linear_regression_plotter(PPS_size, PPS_gradient, icon1, color1, figure_font_size, scatter_size, x_name, y_name, x_lim, x_ticks, y_lim, y_ticks)
    
end