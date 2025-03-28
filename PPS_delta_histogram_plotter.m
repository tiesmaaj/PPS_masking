function [h] = PPS_delta_histogram_plotter(x, y, color, figure_font_size, x_name, y_name, single_group)
% PPS_delta_histogram_plotter: Plots a histogram of delta values with robust binning

    % Compute the delta values
    if single_group
        if y == 0
            delta = x;
        else
            delta = x - y;
        end
    else
        delta = x - y;
    end

    % Remove outliers based on z-scores
    mu = mean(delta, 'omitnan');
    sigma = std(delta, 'omitnan');
    z_scores = (delta - mu) / sigma;
    delta_cleaned = delta(abs(z_scores) <= 3); % Remove outliers
    
    % Auto-define bin width using Freedman-Diaconis rule
    iqr_delta = iqr(delta_cleaned); % Interquartile range
    bin_width = 2 * iqr_delta / nthroot(length(delta_cleaned), 3); % Optimal bin width
    if isnan(bin_width) || bin_width == 0
        bin_width = 1; % Fallback if IQR is zero or undefined
    end

    % Define bin edges dynamically
    max_abs_val = max(abs(delta_cleaned)); % Max absolute value
    max_edge = ceil(max_abs_val / bin_width) * bin_width; % Round up to nearest bin
    bin_edges = -max_edge:bin_width:max_edge; % Ensure symmetry around 0

    % Create histogram
    figure;
    h = histogram(delta_cleaned, 'BinEdges', bin_edges, 'FaceColor', color, 'FaceAlpha', 1, ...
                  'EdgeColor', 'k', 'LineWidth', 2.5);
    xlim([-max_edge max_edge]);  % Symmetric x-axis range

    % Formatting axis labels
    if y == 0
        xlabel_text = x_name;
        xlim([0 max_edge]); % Only positive values for single-group histograms
    else
        xlabel_text = sprintf('%s - %s', x_name, y_name);
    end
    xlabel(xlabel_text, 'FontSize', figure_font_size);

    % Remove y-axis for cleaner look
    ax = gca;
    ax.YAxis.Visible = 'off';

    % Add vertical reference line at x = 0
    hold on;
    plot([0 0], ylim, '--', 'Color', '#bbbbbb', 'LineWidth', 2.5);

    % Calculate median and p-value
    delta_median = median(delta_cleaned, 'omitnan');
    [p] = signrank(delta_cleaned); % Wilcoxon Signed-Rank Test

    % Apply styling
    beautifyplot;
    unmatlabifyplot(1);
    set(findall(gcf, '-property', 'FontSize'), 'FontSize', figure_font_size);

    % Display median and p-value
    y_limits = ylim;
    p_rounded = round(p, 4);
    median_rounded = round(delta_median, 2);
    text_location_x = max_edge * 0.75;
    text_location_y = y_limits(2) * 0.9;

    % Format text output
    if y == 0
        text_str = sprintf('median = %.3f', median_rounded);
    else
        text_str = sprintf('median = %.3f\np = %.3f', median_rounded, p_rounded);
    end
    text(text_location_x, text_location_y, text_str, 'FontSize', 36, 'FontWeight', 'bold', 'FontName', 'Times New Roman');
    
    hold off;
end
