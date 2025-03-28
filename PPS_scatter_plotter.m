function [h]= PPS_scatter_plotter(x_values, y_values, scatter_icon, scatter_color, figure_font_size, scatter_size, x_name, y_name, single_group)
% Scatter Plot
if single_group
    figure;
end
hold on;
plot([0 20], [0 20], '--', 'Color', '#bbbbbb', 'LineWidth', 2.5, 'DisplayName', 'Equal Sensitivity', 'HandleVisibility', 'off');
h = scatter(x_values, y_values, scatter_size, scatter_icon, 'filled', 'MarkerFaceColor', scatter_color);
xlim([0 2]);
ylim([0 2]);
xlabel(x_name, 'FontSize', figure_font_size);
ylabel(y_name, 'FontSize', figure_font_size);
axis square
% Set tick marks 
xticks([0 0.5 1.0 1.5 2.0]);
yticks([0 0.5 1.0 1.5 2.0]);

% Create the legend and adjust its properties
%[h, icons] = legend('show', 'Location', 'northwest', 'FontSize', 30, 'FontName', 'Times New Roman');  % Set legend font size
%h.ItemTokenSize = [25, 25];  % Match the size of the markers in the legend to the scatter plot

beautifyplot;
unmatlabifyplot(0);
set(findall(gcf, '-property', 'FontSize'), 'FontSize', figure_font_size);

if single_group
    hold off;
else
    hold on; % adding more data points to scatter plot
end

end