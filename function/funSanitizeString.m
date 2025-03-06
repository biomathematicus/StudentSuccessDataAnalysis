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
    p = strrep(p,'�','a');
    p = strrep(p,'�','e');
    p = strrep(p,'�','i');
    p = strrep(p,'�','o');
    p = strrep(p,'�','u');
end

