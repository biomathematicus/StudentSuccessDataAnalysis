function txt = aDFWbyInstCURSOR1(empt,event_obj)
% This function creates a custom cursor for DFW by instructor
% Author: Juan B. Gutierrez - juan.gutierrez3@utsa.edu
% Date: 09/2019
    global aDFWbyInstDATA sStart sEnd sSubjectCode person sCourseNumber sGrades
    try
        % Retrieve position in the plot
        pos = get(event_obj,'Position');

        idx =   aDFWbyInstDATA(:,1) == pos(1) & ... 
                aDFWbyInstDATA(:,2) == pos(2) & ...
                aDFWbyInstDATA(:,3) == pos(3);
        sFeature1 = num2str(pos(1));
        sFeature2 = num2str(pos(2));
        sFeature3 = num2str(pos(3));

        % Customizes text of data tips
         txt = {
                    ['Course Level              : ',sFeature1],...
                    ['Total Number of  Students : ',sFeature2],...
                    ['DFW Rate                  : ',sFeature3],...
               };
            aDFWbyCourse(sStart, sEnd, sSubjectCode, person{idx}, sCourseNumber, sGrades)
    catch err
        txt = '';
        disp(err)
    end
end
