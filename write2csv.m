function write2csv(filename, scenario, e2)
    % Check if the file exists
    if exist(filename, 'file')
        % Load the existing data from the CSV file
        existingData = readmatrix(filename);

        % Find the row where the scenario matches the user's input
        matchingRow = find(existingData(:, 1) == scenario);

        if ~isempty(matchingRow)
            % If the scenario already exists, append its value on 
            cur_ind = length(existingData(matchingRow,:));
            for i = 1:cur_ind
                if(existingData(matchingRow,i)==0.0)
                    cur_ind = i-1;
                    break;
                end
            end
            existingData(matchingRow, cur_ind+1) = e2;
        else
            % If the scenario is new, append it to the CSV file
            newData = [scenario, e2];
            existingData = [existingData; newData];
        end

        % Append the updated data to the CSV file
        writematrix(existingData, filename, 'WriteMode', 'overwrite');
    else
        % If the file doesn't exist, create it with a header and add the data
        header = {'scenario', 'energy'};
        data = [scenario, e2];
        writecell(header, filename);
        writematrix(data, filename, 'WriteMode', 'overwrite');
    end
end
