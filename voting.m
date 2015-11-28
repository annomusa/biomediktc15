function [vote, un_sort_vote] = voting(classification_result, k)
    curVote = [];
    
    initClass = [ 'carcinoma          ';
                  'light_displastic   ';
                  'moderate displastic';
                  'nomal intermediate ';
                  'normal comurnal    ' ];
    
    initClass = cellstr(initClass);
    
    for i = 1 : 5
        innerVote.class = initClass(i);
        innerVote.count = 0;
        
        curVote = [curVote, innerVote];
    end
    
    %% before sort
        Afields = fieldnames(classification_result);
        Acell = struct2cell(classification_result);
        sz = size(Acell)
        
        % Convert to a matrix
        Acell = reshape(Acell, sz(1), []);      % Px(MxN)

        % Make each field a column
        Acell = Acell';                         % (MxN)xP

        % Sort by first field "distance"
        Acell = sortrows(Acell, 2);
        
        % Put back into original cell array format
        Acell = reshape(Acell', sz);

        % Convert to Struct
        Asorted = cell2struct(Acell, Afields, 1);
    %%

    %vote = Asorted;

    for i = 1 : k
        for index = 1 : 5
            if (strcmp(curVote(index).class, Asorted(i).class))
                curVote(index).count = curVote(index).count + 1;
            end
        end
    end
    
    un_sort_vote = curVote;
    
    %% before sort
        Afields = fieldnames(curVote);
        Acell = struct2cell(curVote);
        sz = size(Acell)
        
        % Convert to a matrix
        Acell = reshape(Acell, sz(1), []);      % Px(MxN)

        % Make each field a column
        Acell = Acell';                         % (MxN)xP

        % Sort by first field "count"
        Acell = sortrows(Acell, 2);
        
        % Put back into original cell array format
        Acell = reshape(Acell', sz);

        % Convert to Struct
        Asorted = cell2struct(Acell, Afields, 1);
    %%
    
    vote = Asorted;
end