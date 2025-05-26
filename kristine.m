function untitled3
    % Cute Pastel UI with Sidebar, Card, and Tabbed Results
    pastelBg = [0 0 0]; % black background
    pastelSidebar = [0.93 0.89 0.98]; % lighter purple
    pastelCard = [0.96 0.97 1.00]; % baby blue
    pastelButton = [1.00 0.80 0.89]; % pink
    pastelButton2 = [0.80 0.93 1.00]; % blue
    pastelButton3 = [1.00 0.95 0.80]; % yellow
    pastelReset = [1.00 0.80 0.80]; % soft red
    pastelText = [0.40 0.20 0.40]; % deep purple
    fontName = 'Comic Sans MS';
    fig = uifigure('Name','Numerical Method','Position',[100 100 950 600],'Color',pastelBg);

    % Sidebar (cute, pastel)
    % Note: Rounded corners and shadow are not supported in MATLAB uipanel
    sidebar = uipanel(fig, 'Title', '', 'Position', [1 1 240 600], ...
        'BackgroundColor', pastelSidebar, 'BorderType', 'none');
    sidebarGrid = uigridlayout(sidebar, [8, 1], ...
        'RowHeight', {50, 40, 50, 50, 30, 50, 50, '1x'}, ...
        'ColumnWidth', {'1x'}, 'Padding', [18 18 18 18]);

    % Sidebar: Title
    uilabel(sidebarGrid, 'Text', 'Methods', 'FontSize', 26, 'FontWeight', 'bold', ...
        'FontColor', pastelText, 'HorizontalAlignment', 'left', 'FontName', fontName);
    % Sidebar: Method Dropdown
    methodNames = {'Graphical','Bisection','Secant','Newton-Raphson','Regula Falsi','Incremental'};
    methodDropdown = uidropdown(sidebarGrid, ...
        'Items', methodNames, 'FontSize', 20, 'FontWeight', 'bold', ...
        'Value', methodNames{1}, 'Tooltip','Choose a root-finding method', ...
        'BackgroundColor', pastelCard, 'FontColor', pastelText, ...
        'ValueChangedFcn', @(src, event)selectMethod(src.Value), ...
        'FontName', fontName); % No CornerRadius in MATLAB
    % Sidebar: Spacer
    uilabel(sidebarGrid, 'Text', '', 'FontSize', 1);
    % Sidebar: Instructions Button
    instructionsBtn = uibutton(sidebarGrid, 'Text', 'Instructions', 'FontSize', 20, ...
        'FontWeight', 'bold', 'BackgroundColor', pastelButton3, 'FontColor', pastelText, ...
        'Tooltip', 'Show instructions', 'ButtonPushedFcn', @(src, event)buttonFlash(src, @()showInstructions()), ...
        'FontName', fontName); % No CornerRadius in MATLAB
    % Sidebar: Reset Button
    resetBtn = uibutton(sidebarGrid, 'Text', 'Reset', 'FontSize', 20, ...
        'FontWeight', 'bold', 'BackgroundColor', pastelReset, 'FontColor', pastelText, ...
        'Tooltip', 'Reset all fields', 'ButtonPushedFcn', @(src, event)buttonFlash(src, @()resetApp()), ...
        'FontName', fontName); % No CornerRadius in MATLAB
    % Sidebar: Spacer
    uilabel(sidebarGrid, 'Text', '', 'FontSize', 1);
    % Sidebar: Filler
    uilabel(sidebarGrid, 'Text', '', 'FontSize', 1);

    % Main Card Panel (cute, pastel)
    % Note: Rounded corners and shadow are not supported in MATLAB uipanel
    card = uipanel(fig, 'Title', '', 'Position', [260 420 670 120], ...
        'BackgroundColor', pastelCard, ...
        'BorderType', 'line', ...
        'HighlightColor', pastelButton2);
    cardGrid = uigridlayout(card, [2, 4], ...
        'RowHeight', {44, 44}, ...
        'ColumnWidth', {260, 120, 120, 120}, ...
        'Padding', [18 18 18 18], ...
        'ColumnSpacing', 18, ...
        'RowSpacing', 10);
    % First row: Equation input and Run button
    eqEdit = uieditfield(cardGrid, 'text', 'FontSize', 18, 'Value', 'x^3-x-2', ...
        'Placeholder', 'Enter equation, e.g. x^3-x-2', ...
        'BackgroundColor', pastelSidebar, 'FontColor', pastelText, ...
        'HorizontalAlignment', 'left', 'FontName', fontName); % No CornerRadius
    eqEdit.Layout.Row = 1; eqEdit.Layout.Column = [1 3];
    runBtn = uibutton(cardGrid, 'Text', 'Run', 'FontSize', 20, 'FontWeight', 'bold', ...
        'BackgroundColor', pastelButton, 'FontColor', pastelText, ...
        'Tooltip', 'Run selected method', ...
        'ButtonPushedFcn', @(src, event)runMethod(), ...
        'FontName', fontName); % No CornerRadius
    runBtn.Layout.Row = 1; runBtn.Layout.Column = 4;
    % Second row: Lower, Upper, Step fields
    lowerEdit = uieditfield(cardGrid, 'numeric', 'FontSize', 16, 'Value', 0.1, ...
        'Placeholder', 'Lower', ...
        'Limits', [-Inf Inf], 'BackgroundColor', pastelSidebar, 'FontColor', pastelText, 'FontName', fontName); % No CornerRadius
    lowerEdit.Layout.Row = 2; lowerEdit.Layout.Column = 2;
    upperEdit = uieditfield(cardGrid, 'numeric', 'FontSize', 16, 'Value', 10, ...
        'Placeholder', 'Upper', ...
        'Limits', [-Inf Inf], 'BackgroundColor', pastelSidebar, 'FontColor', pastelText, 'FontName', fontName); % No CornerRadius
    upperEdit.Layout.Row = 2; upperEdit.Layout.Column = 3;
    stepEdit = uieditfield(cardGrid, 'numeric', 'FontSize', 16, 'Value', 0.01, ...
        'Placeholder', 'Step', ...
        'Limits', [eps Inf], 'BackgroundColor', pastelSidebar, 'FontColor', pastelText, 'FontName', fontName); % No CornerRadius
    stepEdit.Layout.Row = 2; stepEdit.Layout.Column = 4;
    % Add a blank label for alignment in the first column of the second row
    blankLbl = uilabel(cardGrid, 'Text', '', 'FontSize', 1, 'BackgroundColor', pastelCard, 'FontColor', pastelCard);
    blankLbl.Layout.Row = 2;
    blankLbl.Layout.Column = 1;

    % Tab Group for Results (cute tabs)
    tabg = uitabgroup(fig, 'Position', [260 10 670 400]);
    tab1 = uitab(tabg, 'Title', 'Graph');
    tab2 = uitab(tabg, 'Title', 'Table');
    % Axes in Graph Tab
    ax = uiaxes(tab1, 'Position', [30 60 600 300], 'BackgroundColor', pastelCard);
    ax.XColor = pastelText; ax.YColor = pastelText;
    ax.XLabel.Color = pastelText; ax.YLabel.Color = pastelText;
    ax.Title.Color = pastelText;
    ax.FontName = fontName;
    % Result label above axes
    resultLbl = uilabel(tab1, 'Text', 'Result: ', 'Position', [30 20 600 30], 'FontSize', 18, 'FontColor', pastelText, 'FontName', fontName);
    % Table in Table Tab
    table = uitable(tab2, 'Position', [30 20 600 350], ...
        'ColumnName', {'Iteration', 'x0', 'x1', 'f(x0)', 'f(x1)', 'x2', 'Remark'}, ...
        'Data', {}, ...
        'FontSize', 15, ...
        'BackgroundColor', [0.15 0.15 0.15], ...
        'ColumnWidth', {'auto', 'auto', 'auto', 'auto', 'auto', 'auto', 'auto'}, ...
        'RowName', {}, ...
        'ColumnEditable', false, ...
        'RowStriping', 'on', ...
        'FontWeight', 'bold', ...
        'FontName', fontName, ...
        'CellEditCallback', []);
    tab2.BackgroundColor = [0.15 0.15 0.15];

    % Default interval and settings
    tol = 1e-10; max_iter = 200;
    x = sym('x');
    method = 'Graphical';

    % Remove dropdown, add sidebar logic
    function selectMethod(selectedMethod)
        method = selectedMethod;
        runMethod();
    end

    function runMethod()
        a = lowerEdit.Value;
        b = upperEdit.Value;
        stepsize = stepEdit.Value;
        eq = preprocess_equation(eqEdit.Value);
        % Check for unsupported patterns and provide user guidance
        if contains(eq, 'foo(') || contains(eq, 'bar(')
            uialert(fig, 'Custom functions like foo(x) or bar(x) are not defined. Please define them first or use built-in functions.', 'Unsupported Function');
            return;
        end
        % (REMOVE the block that checks for '=' here)
        if contains(eq, '{n+1}') || contains(eq, 'recurrence')
            uialert(fig, 'Recurrence relations are not directly supported. Please use loops or the symbolic toolbox (rsolve) for such equations.', 'Recurrence Relation');
            return;
        end
        if contains(eq, '\\')
            uialert(fig, 'LaTeX detected. Only basic LaTeX constructs (fractions, sqrt, powers, subscripts) are supported. Please check your input.', 'LaTeX Input');
            return;
        end
        if contains(eq, 'piecewise')
            uialert(fig, 'Piecewise detected. Use the format piecewise(cond1, expr1, cond2, expr2, ...) for best results.', 'Piecewise Input');
            % Not a hard error, just a warning
        end
        if contains(eq, 'symsum') || contains(eq, 'symprod')
            uialert(fig, 'Summation/Product detected. Only simple forms are supported. For advanced cases, use the symbolic toolbox directly.', 'Summation/Product Input');
            % Not a hard error, just a warning
        end
        if contains(eq, 'dirac') || contains(eq, 'heaviside')
            uialert(fig, 'Dirac/Heaviside detected. These are only supported symbolically, not numerically.', 'Dirac/Heaviside Input');
            % Not a hard error, just a warning
        end
        try
            f = matlabFunction(str2sym(eq),'Vars',x);
        catch err
            resultLbl.Text = ['Invalid equation! ', err.message];
            cla(ax);
            return;
        end
        xvals = linspace(a,b,5000); % Higher resolution for accuracy
        yvals = arrayfun(f,xvals);
        % Filter out complex or NaN values for plotting and root finding
        validIdx = isreal(yvals) & ~isnan(yvals);
        xvals_plot = xvals(validIdx);
        yvals_plot = yvals(validIdx);
        cla(ax);
        % Set dark background and axes
        ax.Color = [0.1 0.1 0.1];
        ax.XColor = [1 1 1];
        ax.YColor = [1 1 1];
        ax.XLabel.Color = [1 1 1];
        ax.YLabel.Color = [1 1 1];
        ax.Title.Color = [1 1 1];
        % Set grid and minor grid
        grid(ax,'on');
        ax.XMinorGrid = 'on';
        ax.YMinorGrid = 'on';
        ax.GridColor = [1 1 1];
        ax.MinorGridColor = [0.5 0.5 0.5];
        ax.GridAlpha = 0.3;
        ax.MinorGridAlpha = 0.2;
        % Set axis limits tightly with margin
        if isempty(yvals_plot)
            ax.XLim = [a, b];
            ax.YLim = [-1, 1];
        else
            ypad = 0.05 * (max(yvals_plot)-min(yvals_plot));
            if ypad == 0, ypad = 1; end
            ax.XLim = [min(xvals_plot), max(xvals_plot)];
            ax.YLim = [min(yvals_plot)-ypad, max(yvals_plot)+ypad];
        end
        % Set tick marks for alignment
        ax.XTick = linspace(a, b, 11);
        if ~isempty(yvals_plot)
            ax.YTick = linspace(round(min(yvals_plot)), round(max(yvals_plot)), 9);
        end
        % Plot function in white
        if ~isempty(xvals_plot)
            plot(ax,xvals_plot,yvals_plot,'w','LineWidth',2,'DisplayName','f(x)'); hold(ax,'on');
        end
        % Plot y=0 line in green dashed
        yline(ax,0,'--','Color',[0 1 0],'LineWidth',2,'DisplayName','y=0');
        switch method
            case 'Graphical'
                zero_crossings = find(yvals(1:end-1).*yvals(2:end) < 0);
                roots_approx = (xvals(zero_crossings) + xvals(zero_crossings+1))/2;
                table.ColumnName = {'Approximate Root(s)', 'f(x)'};
                table.Data = [num2cell(roots_approx'), num2cell(arrayfun(f, roots_approx'))];
                if isempty(roots_approx)
                    resultLbl.Text = 'No root detected visually in interval.';
                else
                    resultLbl.Text = sprintf('Approximate root(s): %s', ...
                        num2str(roots_approx, '%.10f '));
                    scatter(ax,roots_approx,zeros(size(roots_approx)),100,'g','filled','DisplayName','Approx Root');
                end
                lgd = legend(ax,'show','Location','best');
                lgd.FontSize = 18;
                its = {}; root = NaN;
            case 'Bisection'
                [root, its] = bisection_method(f,a,b,tol,max_iter);
                table.ColumnName = {'Iteration', 'a', '\u0394x', 'b', 'f(a)', 'f(b)', 'f(a)*f(b)', 'Remark'};
                if ~isempty(its)
                    % Format numbers to 6 decimal places for readability
                    for i = 1:size(its,1)
                        for j = 2:7 % Columns with numbers
                            if isnumeric(its{i,j}) && ~isnan(its{i,j})
                                its{i,j} = sprintf('%.6f', its{i,j});
                            end
                        end
                    end
                    for k = 1:size(its,1)
                        x1 = str2double(its{k,2}); xu = str2double(its{k,4});
                        if k == 1
                            plot(ax, [x1 xu], [0 0], 'bo-', 'LineWidth', 1.5, 'DisplayName', 'Interval');
                        else
                            plot(ax, [x1 xu], [0 0], 'bo-', 'LineWidth', 1.5, 'HandleVisibility','off');
                        end
                    end
                end
                scatter(ax,root,f(root),100,'r','filled','DisplayName','Root');
                lgd = legend(ax,'show','Location','best');
                lgd.FontSize = 18;
            case 'Secant'
                [root, its] = secant_method(f,a,b,tol,max_iter);
                table.ColumnName = {'Iteration', 'x0', 'x1', 'f(x0)', 'f(x1)', 'x2', 'Remark'};
                if ~isempty(its)
                    % Format numbers to 6 decimal places for readability
                    for i = 1:size(its,1)
                        for j = 2:6 % Columns with numbers
                            if isnumeric(its{i,j}) && ~isnan(its{i,j})
                                its{i,j} = sprintf('%.6f', its{i,j});
                            end
                        end
                    end
                    x0s = cellfun(@str2double, its(:,2));
                    x1s = cellfun(@str2double, its(:,3));
                    if ~isempty(x0s)
                        scatter(ax, x0s, f(x0s), 60, 'b', 'filled', 'DisplayName', 'x0');
                    end
                    if ~isempty(x1s)
                        scatter(ax, x1s, f(x1s), 60, 'g', 'filled', 'DisplayName', 'x1');
                    end
                    for k = 1:size(its,1)
                        x0_sec = str2double(its{k,2}); x1_sec = str2double(its{k,3});
                        f0_sec = str2double(its{k,4}); f1_sec = str2double(its{k,5});
                        if k == 1
                            plot(ax, [x0_sec x1_sec], [f0_sec f1_sec], 'Color', [0.2 0.8 0.2], 'LineWidth', 1.5, 'DisplayName', 'Secant');
                        else
                            plot(ax, [x0_sec x1_sec], [f0_sec f1_sec], 'Color', [0.2 0.8 0.2], 'LineWidth', 1.5, 'HandleVisibility','off');
                        end
                    end
                end
                scatter(ax,root,f(root),100,'r','filled','DisplayName','Root');
                lgd = legend(ax,'show','Location','best');
                lgd.FontSize = 18;
            case 'Newton-Raphson'
                try
                    df = matlabFunction(diff(str2sym(eq),x),'Vars',x);
                    [root, its] = newton_raphson_method(f,df,(a+b)/2,tol,max_iter);
                    table.ColumnName = {'Iteration', 'x0', 'f(x0)', 'df(x0)', 'x1', 'Remark'};
                    if ~isempty(its)
                        % Format numbers to 6 decimal places for readability
                        for i = 1:size(its,1)
                            for j = 2:5 % Columns with numbers
                                if isnumeric(its{i,j}) && ~isnan(its{i,j})
                                    its{i,j} = sprintf('%.6f', its{i,j});
                                end
                            end
                        end
                        x0s = cellfun(@str2double, its(:,2));
                        if ~isempty(x0s)
                            scatter(ax, x0s, f(x0s), 60, 'b', 'filled', 'DisplayName', 'x0');
                        end
                        for k = 1:size(its,1)
                            x0n = str2double(its{k,2}); fx0n = str2double(its{k,3}); dfx0n = str2double(its{k,4});
                            tangent_x = linspace(x0n-1, x0n+1, 10);
                            tangent_y = fx0n + dfx0n*(tangent_x-x0n);
                            if k == 1
                                plot(ax, tangent_x, tangent_y, '--', 'Color', [0.8 0.2 0.8], 'LineWidth', 1, 'DisplayName', 'Tangent');
                            else
                                plot(ax, tangent_x, tangent_y, '--', 'Color', [0.8 0.2 0.8], 'LineWidth', 1, 'HandleVisibility','off');
                            end
                        end
                    end
                    scatter(ax,root,f(root),100,'r','filled','DisplayName','Root');
                    lgd = legend(ax,'show','Location','best');
                    lgd.FontSize = 18;
                catch err
                    resultLbl.Text = ['Error in Newton-Raphson: ', err.message];
                    return;
                end
            case 'Regula Falsi'
                [root, its] = regula_falsi_method(f,a,b,tol,max_iter);
                table.ColumnName = {'Iteration', 'a', '\u0394x', 'b', 'f(a)', 'f(b)', 'f(a)*f(b)', 'Remark'};
                if ~isempty(its)
                    % Format numbers to 6 decimal places for readability
                    for i = 1:size(its,1)
                        for j = 2:7 % Columns with numbers
                            if isnumeric(its{i,j}) && ~isnan(its{i,j})
                                its{i,j} = sprintf('%.6f', its{i,j});
                            end
                        end
                    end
                    for k = 1:size(its,1)
                        x1 = str2double(its{k,2}); xu = str2double(its{k,4});
                        if k == 1
                            plot(ax, [x1 xu], [0 0], 'mo-', 'LineWidth', 1.5, 'DisplayName', 'Interval');
                        else
                            plot(ax, [x1 xu], [0 0], 'mo-', 'LineWidth', 1.5, 'HandleVisibility','off');
                        end
                    end
                end
                scatter(ax,root,f(root),100,'r','filled','DisplayName','Root');
                lgd = legend(ax,'show','Location','best');
                lgd.FontSize = 18;
            case 'Incremental'
                [root, its] = incremental_search_method(f, a, b, tol, max_iter);
                table.ColumnName = {'Iteration', 'x0', 'x1', 'f(x0)', 'f(x1)', 'Remark'};
                if ~isempty(its)
                    % Format numbers to 6 decimal places for readability
                    for i = 1:size(its,1)
                        for j = 2:5 % Columns with numbers
                            if isnumeric(its{i,j}) && ~isnan(its{i,j})
                                its{i,j} = sprintf('%.6f', its{i,j});
                            end
                        end
                    end
                    x0s = cellfun(@str2double, its(:,2));
                    x1s = cellfun(@str2double, its(:,3));
                    scatter(ax, x0s, f(x0s), 60, 'b', 'filled', 'DisplayName', 'x0');
                    scatter(ax, x1s, f(x1s), 60, 'g', 'filled', 'DisplayName', 'x1');
                    for k = 1:size(its,1)
                        x1 = double(its{k,2});
                        x2 = double(its{k,3});
                        y1 = double(its{k,4});
                        y2 = double(its{k,5});
                        if all(isfinite([x1 x2 y1 y2])) && numel([x1 x2]) == 2 && numel([y1 y2]) == 2
                            plot(ax, [x1 x2], [y1 y2], 'c-', 'LineWidth', 1.5, 'HandleVisibility','off');
                        end
                    end
                end
                if ~isnan(root)
                    scatter(ax,root,f(root),100,'r','filled','DisplayName','Root');
                end
                lgd = legend(ax,'show','Location','best');
                lgd.FontSize = 18;
        end
        if isempty(its)
            table.Data = {};
        else
            table.Data = its;
        end
        if isnan(root)
            resultLbl.Text = 'No root found in interval.';
        else
            resultLbl.Text = sprintf('Root ≈ %.10f',root);
        end
        hold(ax,'off');
        ax.Title.String = ['Method: ',method];
        ax.XLabel.String = 'x';
        ax.YLabel.String = 'f(x)';
        % grid(ax,'on'); (already set above)
    end

    function resetApp()
        eqEdit.Value = 'x^3-x-2';
        methodDropdown.Value = methodNames{1};
        cla(ax, 'reset');
        hold(ax, 'off');
        table.Data = {};
        resultLbl.Text = 'Result: ';
    end

    function showInstructions()
        msg = sprintf([ ...
            'Instructions:\n', ...
            '1. Enter your function f(x) in the input box at the top.\n', ...
            '2. Select a root-finding method from the dropdown.\n', ...
            '3. Click ''Run'' to compute and visualize the root.\n', ...
            '4. Switch between Graph and Table tabs for results.\n', ...
            '5. Click ''Reset'' to clear and start over.' ...
        ]);
        uialert(fig, msg, 'Instructions');
    end

    function buttonFlash(btn, callback)
        origColor = btn.BackgroundColor;
        btn.BackgroundColor = [0.2 0.6 1];
        t = timer('StartDelay', 0.15, 'TimerFcn', @(~,~)resetColor());
        start(t);
        function resetColor()
            btn.BackgroundColor = origColor;
            delete(t);
            callback();
        end
    end

    % --- Hover animation logic can be adapted if desired ---
    % (Omitted for brevity, but can be re-added for buttons if needed)
end

function eq = preprocess_equation(eq)
    eq = strtrim(eq);
    
    % Handle common trigonometric patterns first
    eq = regexprep(eq, 'sin\((.*?)\)\s*=\s*0', 'sin($1)');
    eq = regexprep(eq, 'cos\((.*?)\)\s*=\s*0', 'cos($1)');
    eq = regexprep(eq, 'tan\((.*?)\)\s*=\s*0', 'tan($1)');
    
    % Convert equations of the form expr1 = expr2 to expr1 - (expr2)
    eqParts = regexp(eq, '^(.*)=(.*)$', 'tokens', 'once');
    if ~isempty(eqParts)
        eq = [strtrim(eqParts{1}) ' - (' strtrim(eqParts{2}) ')'];
    end
    
    % Rest of the preprocessing
    eq = strrep(eq,'^','.^');
    eq = regexprep(eq,'ln\((.*?)\)','log($1)');
    eq = regexprep(eq,'e\^([a-zA-Z0-9_()]+)','exp($1)');
    eq = regexprep(eq,'\bpi\b','pi');
    eq = regexprep(eq,'\be\b','exp(1)');
    
    % Insert * for implicit multiplication
    eq = regexprep(eq,'(\d)([a-zA-Z])','$1*$2');
    eq = regexprep(eq,'([a-zA-Z])(\d)','$1*$2');
    eq = regexprep(eq,'(\d)\(','$1*(');
    eq = regexprep(eq,'([a-zA-Z])\(','$1*(');
    eq = regexprep(eq,'\)\(','\)*(');
    eq = regexprep(eq,'\)([a-zA-Z])','\)*$1');
    
    % Factorial
    eq = regexprep(eq, '(\w+)!', 'factorial($1)');
    
    % Absolute value: convert |...| to abs(...)
    eq = regexprep(eq, '\|([^\|]+)\|', 'abs($1)');
    
    % Greek letters (expanded)
    greek_map = { ...
        'α', 'alpha'; 'β', 'beta'; 'γ', 'gamma'; 'δ', 'delta'; 'ε', 'epsilon'; 'ζ', 'zeta';
        'η', 'eta'; 'θ', 'theta'; 'ι', 'iota'; 'κ', 'kappa'; 'λ', 'lambda'; 'μ', 'mu';
        'ν', 'nu'; 'ξ', 'xi'; 'ο', 'omicron'; 'π', 'pi'; 'ρ', 'rho'; 'σ', 'sigma';
        'τ', 'tau'; 'υ', 'upsilon'; 'φ', 'phi'; 'χ', 'chi'; 'ψ', 'psi'; 'ω', 'omega';
        'Α', 'Alpha'; 'Β', 'Beta'; 'Γ', 'Gamma'; 'Δ', 'Delta'; 'Ε', 'Epsilon'; 'Ζ', 'Zeta';
        'Η', 'Eta'; 'Θ', 'Theta'; 'Ι', 'Iota'; 'Κ', 'Kappa'; 'Λ', 'Lambda'; 'Μ', 'Mu';
        'Ν', 'Nu'; 'Ξ', 'Xi'; 'Ο', 'Omicron'; 'Π', 'Pi'; 'Ρ', 'Rho'; 'Σ', 'Sigma';
        'Τ', 'Tau'; 'Υ', 'Upsilon'; 'Φ', 'Phi'; 'Χ', 'Chi'; 'Ψ', 'Psi'; 'Ω', 'Omega'
    };
    for k = 1:size(greek_map,1)
        eq = strrep(eq, greek_map{k,1}, greek_map{k,2});
    end
    
    % LaTeX constructs
    eq = regexprep(eq, '\\frac{([^}]+)}{([^}]+)}', '($1)/($2)');
    eq = regexprep(eq, '\\sqrt{([^}]+)}', 'sqrt($1)');
    eq = regexprep(eq, '([a-zA-Z0-9_]+)\^\{([^}]+)\}', '$1^$2');
    eq = regexprep(eq, '([a-zA-Z0-9_]+)_\{([^}]+)\}', '$1$2');
    eq = strrep(eq, '\left(', '(');
    eq = strrep(eq, '\right)', ')');
    
    % Summation/Product (expanded)
    eq = regexprep(eq, 'sum_{(\w+)=(\d+)}\^{(\w+)}\s*([^\s]+)', 'symsum($4, $1, $2, $3)');
    eq = regexprep(eq, 'prod_{(\w+)=(\d+)}\^{(\w+)}\s*([^\s]+)', 'symprod($4, $1, $2, $3)');
    
    % Piecewise (advanced)
    eq = regexprep(eq, '{\s*([^,;]+),\s*([^;]+);\s*([^,;]+),\s*([^}]+)\s*}', ...
        'piecewise($2, $1, $4, $3)');
    
    % Function calls without parentheses
    function_names = 'sin|cos|tan|exp|log|sqrt|abs|asin|acos|atan|sinh|cosh|tanh|floor|ceil|sign';
    eq = regexprep(eq, ['\\b(' function_names ')\\s+([a-zA-Z][a-zA-Z0-9_]*)\\b'], '$1($2)');
    
    % Rearrange equations of the form f(x) = g(x) to f(x) - (g(x))
    if contains(eq, '=')
        parts = split(eq, '=');
        if numel(parts) == 2
            eq = sprintf('(%s)-(%s)', strtrim(parts{1}), strtrim(parts{2}));
        end
    end
    
    % Inequalities
    eq = regexprep(eq, '([a-zA-Z0-9_]+)\s*<=\s*([a-zA-Z0-9_]+)', '$1 <= $2');
    eq = regexprep(eq, '([a-zA-Z0-9_]+)\s*>=\s*([a-zA-Z0-9_]+)', '$1 >= $2');
    eq = regexprep(eq, '([a-zA-Z0-9_]+)\s*<\s*([a-zA-Z0-9_]+)', '$1 < $2');
    eq = regexprep(eq, '([a-zA-Z0-9_]+)\s*>\s*([a-zA-Z0-9_]+)', '$1 > $2');
end

function [root, iterations] = bisection_method(f, a, b, tol, max_iter)
    if f(a)*f(b) >= 0, root = NaN; iterations = {}; return; end
    iterations = {};
    for i = 1:max_iter
        c = (a+b)/2;
        fa = f(a); fb = f(b); fc = f(c);
        delta = b - a;
        prod = fa * fb;
        remark = 'Go to next interval';
        iterations(end+1,:) = {i, a, delta, b, fa, fb, prod, remark};
        if abs(fc) < tol || delta/2 < tol, root = c; return; end
        if fa*fc < 0, b = c; else, a = c; end
    end
    root = c;
end

function [root, iterations] = secant_method(f, x0, x1, tol, max_iter)
    iterations = {}; % Always initialize
    fx0 = f(x0);
    fx1 = f(x1);
    x2 = x1; % Initialize x2 to avoid "Unrecognized variable" error
    for k = 1:max_iter
        if abs(fx1 - fx0) < eps
            remark = 'Divide by zero';
            iterations(end+1,:) = {k, x0, x1, fx0, fx1, NaN, remark};
            root = x1; % Assign root to last valid value
            return;
        end
        x2 = x1 - fx1 * (x1 - x0) / (fx1 - fx0);
        remark = '';
        iterations(end+1,:) = {k, x0, x1, fx0, fx1, x2, remark};
        if abs(x2 - x1) < tol
            root = x2;
            return;
        end
        x0 = x1;
        fx0 = fx1;
        x1 = x2;
        fx1 = f(x1);
    end
    root = x2; % Always assign root at the end
end

function [root, iterations] = newton_raphson_method(f, df, x0, tol, max_iter)
    iterations = {}; % Always initialize
    x1 = x0; % Initialize x1 to avoid "Unrecognized variable" error
    for k = 1:max_iter
        fx0 = f(x0);
        dfx0 = df(x0);
        if abs(dfx0) < eps
            remark = 'Zero derivative';
            iterations(end+1,:) = {k, x0, fx0, dfx0, NaN, remark};
            root = x0; % Assign root to last valid value
            return;
        end
        x1 = x0 - fx0 / dfx0;
        remark = '';
        iterations(end+1,:) = {k, x0, fx0, dfx0, x1, remark};
        if abs(x1 - x0) < tol
            root = x1;
            return;
        end
        x0 = x1;
    end
    root = x1; % Always assign root at the end
end

function [root, iterations] = regula_falsi_method(f, a, b, tol, max_iter)
    if f(a)*f(b) >= 0, root = NaN; iterations = {}; return; end
    iterations = {};
    for i = 1:max_iter
        fa = f(a); fb = f(b);
        c = (a*fb - b*fa)/(fb-fa);
        fc = f(c);
        delta = b - a;
        prod = fa * fb;
        remark = 'Go to next interval';
        iterations(end+1,:) = {i, a, delta, b, fa, fb, prod, remark};
        if abs(fc) < tol, root = c; return; end
        if fa*fc < 0, b = c; else, a = c; end
    end
    root = c;
end

function [root, iterations] = incremental_search_method(f, a, b, tol, max_iter)
    % Accurate incremental search for root intervals
    iterations = {};
    N = 1000; % Number of increments
    x0 = a;
    dx = (b-a)/N;
    found = false;
    for i = 1:N
        x1 = x0 + dx;
        fx0 = f(x0);
        fx1 = f(x1);
        remark = '';
        if fx0*fx1 < 0
            found = true;
            remark = 'Sign change detected';
            iterations(end+1,:) = {i, x0, x1, fx0, fx1, remark};
            break;
        else
            remark = 'No sign change';
            iterations(end+1,:) = {i, x0, x1, fx0, fx1, remark};
        end
        x0 = x1;
        if i >= max_iter, break; end
    end
    if found
        % Refine root using bisection in the detected interval
        [root, ~] = bisection_method(f, iterations{end,2}, iterations{end,3}, tol, max_iter);
    else
        root = NaN;
    end
end

function simulate_hover_button
    fig = uifigure('Position', [100 100 400 200]);
    btn = uibutton(fig, 'Position', [150 80 100 40], 'Text', 'Hover Me');
    origPos = btn.Position;
    origFont = btn.FontSize;
    isHovered = false;

    fig.WindowButtonMotionFcn = @(src, event)onMouseMove();

    function onMouseMove()
        mouse = fig.CurrentPoint;
        btnPos = btn.Position;
        % Check if mouse is inside button
        if mouse(1) >= btnPos(1) && mouse(1) <= btnPos(1)+btnPos(3) && ...
           mouse(2) >= btnPos(2) && mouse(2) <= btnPos(2)+btnPos(4)
            if ~isHovered
                btn.Position = [btnPos(1)-5 btnPos(2)-5 btnPos(3)+10 btnPos(4)+10];
                btn.FontSize = origFont * 1.15;
                isHovered = true;
            end
        else
            if isHovered    
                btn.Position = origPos;
                btn.FontSize = origFont;
                isHovered = false;
            end
        end
    end
end
