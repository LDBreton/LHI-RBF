function r = numeric_t(expression,class_t)
        if(strcmpi(class_t,'mp')), r = mp(expression); 
        else
            if isnumeric(expression)
                r = double(expression);
            else
                r = eval(expression);
            end;
        end;
end