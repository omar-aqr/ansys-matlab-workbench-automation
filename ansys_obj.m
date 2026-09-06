function fitness = ansys_obj (x)
    
    % Extract parameters from input depending on your problem/simulation
    Inner = x(2);
    Outer = x(1);

    % Generate unique Excel file name to avoid file collisions
    filenumb = randi(100000,1);

    % Read Base Journal Template
    fid = fopen('Base Journal.wbjn','r');
    f = fread(fid,'*char')';
    fclose(fid);
    
    % Inject Design Variables & Output File Name
    f = strrep(f,'Inner', num2str(Inner));
    f = strrep(f,'Outer', num2str(Outer));
    f = strrep(f,'output_results', num2str(filenumb));
    

    % Write Executable Journal
    fid = fopen('finaljournal.wbjn','w');
    fprintf(fid,'%s',f);
    fclose(fid);


    % Execute ANSYS Workbench in Batch Mode (-B = Batch, -R = Run Script)
    % Note: Adjust the path according to the software you're using
    ansysWB = '"C:\Program Files\ANSYS Inc\ANSYS Student\v261\Framework\bin\Win64\RunWB2.exe"';
    journal = ['"', fullfile(pwd,'finaljournal.wbjn'), '"'];
    cmd = [ansysWB, ' -B -R ', journal];
    
    [status,cmdout] = system(cmd);
    if status~=0
        error('Ansys execution failed: %s', cmdout);
    end

    % Extract objective result from CSV
    filename = sprintf('%i.csv', filenumb);
    fid = fopen(filename,'r');
    lines = textscan(fid,'%s','Delimiter','\n','Whitespace','');
    fclose(fid);
    lines = lines{1};

    % Locate design point line
    dpLineIdx = find(startsWith(lines,'DP'));
    if isempty(dpLineIdx)
        error('Could not find DP line in %s', filename);
    end

    dpLine = strtrim(extractAfter(lines{dpLineIdx},'DP '));
    valuesStr = strsplit(dpLine, ',');
    values = str2double(valuesStr(2:end));
    
    % Objective value (Last row/column)
    fitness = values(end);

    %% If you want to cleanup temporary files to avoid clutter
    % delete(finaljournal.wbjn);
    % delete(filename.csv);
end
