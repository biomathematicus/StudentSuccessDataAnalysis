function fig = funNewFig(varargin)
    fig = figure(); 
    set(fig, 'Visible', 'off');
    set(fig,'renderer','Painters')
    %clf;
    %set(fig,'WindowStyle','docked');
    if  nargin==0
        set(gcf, 'Position',  [100, 100, 800, 900]);
    else
        set(gcf, 'Position',  [100, 100, 1200, 800]);
    end
    colormap parula;
end

