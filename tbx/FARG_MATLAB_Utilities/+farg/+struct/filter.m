function [FiltData,I] = filter(DataStruct,filters)
% FILTER method to extract a logical array of rows in a data structure 
% which match the filters specified in 'filters'. This is a cell array 
% where each array isa single filter, hence filters can be combined. each 
% filter is also a cell array and can take a few forms. The first value is 
% always the 'field' in the structure to apply the filter on and the second
% item can either be:
%   A single value - 
%       {'mychannel',5} or {'mychannel','some string'}
%   An array of possible values - 
%       {'mychannel',[5,10]}
%   A range of values between -
%       {'mychannel',{'range',[-2,2]}}
%   A array of possible string values
%       {'mychannel',{'contains',{'string1','string2'}}}
%   A function that returns a logical array -
%       {'mychannel',@(x)x>5 & x<23}
%       or
%       {'mychannel',@(x)contains(x,{'string1','string2'})}
%       etc...
%
% The function will return the filtered structure and the indicies 
% of the filtered components in DataStruct
%
% created:  11/03/2021
% author:   Fintan Healy
% email:    fintan.healy@bristol.ac.uk
%

if iscell(filters)
    tmpFilt = struct();
    for i = 1:length(filters)
        tmpFilt.(filters{i}{1}) = filters{i}{2};
    end
    filters = tmpFilt;
end
I = true(1,length(DataStruct));
names = fieldnames(filters);
for i = 1:length(names)
    fieldname = names{i};
    tmpfilt = filters.(fieldname);
    if ischar(fieldname)
        if ~isfield(DataStruct,fieldname)
            warning('skipping filter on field %s as it does not exist',fieldname);
        else
            %if here field exists to filter on   
            % if its a function do minimal stuff to the data
            if isa(tmpfilt,'function_handle')
                data = {DataStruct.(fieldname)};
                if length(data) ~= length(I)
                    error('data length for field %s does not have the correct length, check for and remove ''empty'' rows',fieldname)
                end
                try
                    I = I & cellfun(tmpfilt,{DataStruct.(fieldname)});
                catch
                    warning('Error using function handle on field %s',fieldname);
                    continue
                end       
            % check if field is numeric or a string
            elseif ischar(DataStruct(1).(fieldname)) || isstring(DataStruct(1).(fieldname)) || iscellstr(DataStruct(1).(fieldname))
                data = string({DataStruct.(fieldname)});
                % if data is a string check filter is a string or a set of cell array of strings
                if ischar(tmpfilt) || isstring(tmpfilt)
                    I = I & ismember(data,tmpfilt);
                % if its a cell of multiple filters filter by all of them
                elseif iscell(tmpfilt)
                    for j= 1:length(tmpfilt)
                        if ischar(tmpfilt{j})        
                            if j == 1
                                I_temp = strcmp(data,tmpfilt{j});  
                            else
                                I_temp = I_temp | strcmp(data,tmpfilt{j});       
                            end       
                        end
                    end
                    I = I & I_temp;
                end                                 
            % check if numeric    
            elseif isnumeric(DataStruct(1).(fieldname))
                data = [DataStruct.(fieldname)];
                % if filter numeric filter for each item in array
                if isnumeric(tmpfilt) && ~isempty(tmpfilt)
                    I_temp = zeros(size(data));
                    for j= 1:length(tmpfilt)
                        if isnan(tmpfilt(j))
                            I_temp = I_temp | isnan(data);
                        else
                            I_temp = I_temp | data == tmpfilt(j);  
                        end
                    end
                    I = I & I_temp;
                elseif iscell(tmpfilt)
                    if strcmp(tmpfilt{1},'range')
                        if isnumeric(tmpfilt{2}) && length(tmpfilt{2}) == 2
                            bounds = tmpfilt{2};
                            I = I & (data >= bounds(1) & data <= bounds(2));
                        end
                    elseif strcmp(tmpfilt{1},'contains')
                        if ischar(tmpfilt{2})
                            I = I & contains(data,tmpfilt{2});
                        end
                    elseif strcmp(tmpfilt{1},'tol')
                        if isnumeric(tmpfilt{2}) && isnumeric(tmpfilt{3})
                            val = tmpfilt{2};
                            tol = tmpfilt{3};
                            tmp_I = (data >= val(1)-tol & data <= val(1)+tol);
                            for v_i = 2:length(val)
                                tmp_I = tmp_I|(data >= val(v_i)-tol & data <= val(v_i)+tol);
                            end
                            I = I & tmp_I;
                        end
                    end
                end
            elseif isenum(DataStruct(1).(fieldname))
                data = [DataStruct.(fieldname)];
                % if filter numeric filter for each item in array
                if isenum(tmpfilt) && ~isempty(tmpfilt)
                    I_temp = zeros(size(data));
                    for j= 1:length(tmpfilt)
                        I_temp = I_temp | data == tmpfilt(j);                    
                    end
                    I = I & I_temp;
                end
            elseif islogical(DataStruct(1).(fieldname))
                data = [DataStruct.(fieldname)];
                if islogical(tmpfilt) || isnumeric(tmpfilt)
                    I = I & (data == tmpfilt);
                end
            else
                warning('Skipping field %s, as the 1st row is an unknown data type',fieldname);
            end
        end
        
    end   
end
FiltData = DataStruct(I);
end
