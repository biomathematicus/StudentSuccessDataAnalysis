function p = funSanitizeString(s)
    p = strrep(s,'.33', '-Summer');
    p = strrep(p,'.66', '-Fall');
    p = strrep(p,'.00', '-Spring');
    p = strrep(p,'.','-');
    p = strrep(p,'''','-');
    p = strrep(p,'_','-');
    p = strrep(p,'%','');
    p = strrep(p,'#','');
    p = strrep(p,'&','and');
    p = strrep(p,'$','');
    p = strrep(p,':','-');
    p = strrep(p,'/','-');
    p = strrep(p,'\','-');
    p = strrep(p,'á','a');
    p = strrep(p,'é','e');
    p = strrep(p,'í','i');
    p = strrep(p,'ó','o');
    p = strrep(p,'ú','u');
end

