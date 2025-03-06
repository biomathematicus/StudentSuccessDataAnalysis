function TeXout = funPrintImage(h,sName,nFontSize)
    % Create file with plot
    figure(h)
    set(gca,'FontSize',nFontSize);
    sName = strrep(sName,'.','');
    sName = strrep(sName,'\','');
    sName = strrep(sName,'/','');
    sName = strrep(sName,'%','ALL');
    sName = strrep(sName, ' ', '-');
    sName = strrep(sName, ',', '-');
    sFileName = ['../figure/' sName];
    print ('-djpeg100', [sFileName   '.jpg']);
    %funCropImage(sFileName);
    % sFileName = ['..' filesep 'figure' filesep sName  '.pdf'];
    % print ('-dpdf', sFileName);
     funPrintPDF(h,[sFileName   '.pdf']);
     TeXout = [ '\\begin{figure}[ht]' newline ... 
                '  \\centering ' newline ...
                '    \\includegraphics[width=1\\textwidth]{' [sFileName '.pdf'] '}' newline ... 
                '    \\caption{' sName '}' newline ...
                '    \\label{fig:' sFileName '}' newline ...
                '\\end{figure}' newline newline ];
end

