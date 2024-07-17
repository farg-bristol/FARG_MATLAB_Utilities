function [f,tt] = pubFig(opts)
arguments
    opts.Num = 1;
    opts.Layout = [1,1];
    opts.Size = [8,10];
    opts.Pos = [4,4];
end
    f = figure(opts.Num);
    f.Units = "centimeters";
    f.Position = [opts.Pos,opts.Size];
    clf;
    tt = tiledlayout(opts.Layout(1),opts.Layout(2));
    tt.TileSpacing = "compact";
    tt.Padding = "compact";
    for i = 1:(opts.Layout(1)*opts.Layout(2))
        ax = nexttile(i);
        hold on
        grid on
        box on
        ax.FontSize = 10;
    end
end