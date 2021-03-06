if ~isfield(DAT, 'contrasts') || isempty(DAT.contrasts)
    
    % skip
    disp('No contrasts specified. Skipping contrast estimation');

    return
end


%% T-test on each contrast image
% ------------------------------------------------------------------------
docompact2 = 0;  % 0 for default, 1 for compact2 version

    
printhdr('Contrast maps - OLS t-tests');

k = size(DAT.contrasts, 1);
contrast_t_fdr = {};

if docompact2
    o2 = canlab_results_fmridisplay([], 'compact2', 'noverbose');
    whmontage = 1;
else
    create_figure('fmridisplay'); axis off
    o2 = canlab_results_fmridisplay([], 'noverbose');
    whmontage = 5;
end

for i = 1:k
    
    figtitle = sprintf('%s_05_FDR', DAT.contrastnames{i});
    figstr = format_strings_for_legend(figtitle); 
    figstr = figstr{1};
    printhdr(figstr);

    contrast_t_fdr{i} = ttest(DATA_OBJ_CON{i}, .05, 'fdr');
    
    % 1st plot at 0.05 FDR
    % -----------------------------------------------
    o2 = removeblobs(o2);
    o2 = addblobs(o2, region(contrast_t_fdr{i}), 'splitcolor', {[0 0 1] [0 1 1] [1 .5 0] [1 1 0]});
    
    axes(o2.montage{whmontage}.axis_handles(5));
    title(figstr, 'FontSize', 18)

    drawnow, snapnow
    savename = fullfile(figsavedir, [figtitle '.png']);
    saveas(gcf, savename);

    % 2nd plot at 0.01 uncorrected
    % -----------------------------------------------
    figtitle = sprintf('%s_01_unc', DAT.contrastnames{i});
    figstr = format_strings_for_legend(figtitle);
    figstr = figstr{1};
    printhdr(figstr);
    
    o2 = removeblobs(o2);
    contrast_t_unc{i} = threshold(contrast_t_fdr{i}, .01, 'unc');
    o2 = addblobs(o2, region(contrast_t_unc{i}), 'splitcolor', {[0 0 1] [0 1 1] [1 .5 0] [1 1 0]});

    axes(o2.montage{whmontage}.axis_handles(5));
    title(figstr, 'FontSize', 18)
    
    drawnow, snapnow
    savename = fullfile(figsavedir, [figtitle '.png']);
    saveas(gcf, savename);
    
end

%% T-test on Windsorized and CSF-adjusted contrast images
% ------------------------------------------------------------------------
    
printhdr('Contrast maps - OLS t-tests, Windsorized and CSF-adjusted');

k = size(DAT.contrasts, 1);
contrast_t_fdr = {};

o2 = removeblobs(o2);

for i = 1:k
    
    figtitle = sprintf('%s_05_WMCSFsc_FDR', DAT.contrastnames{i});
    figstr = format_strings_for_legend(figtitle); 
    figstr = figstr{1};
    printhdr(figstr);

    contrast_t_fdr{i} = ttest(DATA_OBJ_CONsc{i}, .05, 'fdr');
    
    % 1st plot at 0.05 FDR
    % -----------------------------------------------
    o2 = removeblobs(o2);
    o2 = addblobs(o2, region(contrast_t_fdr{i}), 'splitcolor', {[0 0 1] [0 1 1] [1 .5 0] [1 1 0]});
    
    axes(o2.montage{whmontage}.axis_handles(5));
    title(figstr, 'FontSize', 18)

    drawnow, snapnow
    savename = fullfile(figsavedir, [figtitle '.png']);
    saveas(gcf, savename);

    % 2nd plot at 0.01 uncorrected
    % -----------------------------------------------
    figtitle = sprintf('%s_01_unc', DAT.contrastnames{i});
    figstr = format_strings_for_legend(figtitle);
    figstr = figstr{1};
    printhdr(figstr);
    
    o2 = removeblobs(o2);
    contrast_t_unc{i} = threshold(contrast_t_fdr{i}, .01, 'unc');
    o2 = addblobs(o2, region(contrast_t_unc{i}), 'splitcolor', {[0 0 1] [0 1 1] [1 .5 0] [1 1 0]});

    axes(o2.montage{whmontage}.axis_handles(5));
    title(figstr, 'FontSize', 18)
    
    drawnow, snapnow
    savename = fullfile(figsavedir, [figtitle '.png']);
    saveas(gcf, savename);
    
end
