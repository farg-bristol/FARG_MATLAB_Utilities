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

I = true(1,length(DataStruct));
for i = 1:length(filters)
    fieldname = filters{i}{1};
    if ischar(fieldname)
        if ~isfield(DataStruct,fieldname)
            warning('skipping filter on field %s as it does not exist',fieldname);
        else
            %if here field exists to filter on   
            % if its a function do minimal stuff to the data
            if isa(filters{i}{2},'function_handle')
                try
                    if isnumeric(DataStruct(1).(fieldname)) || islogical(DataStruct(1).(fieldname)) || isenum(DataStruct(1).(fieldname))
                        I = I & cellfun(filters{i}{2},{DataStruct.(fieldname)});
                    else
                        I = I & cellfun(filters{i}{2},{DataStruct.(fieldname)});
                    end
                catch
                    warning('Error using function handle on field %s',fieldname);
                    continue
                end       
            % check if field is numeric or a string
            elseif ischar(DataStruct(1).(fieldname)) || isstring(DataStruct(1).(fieldname)) || iscellstr(DataStruct(1).(fieldname))
                data = string({DataStruct.(fieldname)});
                % if data is a string check filter is a string or a set of cell array of strings
                if ischar(filters{i}{2}) || isstring(filters{i}{2})
                    I = I & strcmp(data,filters{i}{2});
                % if its a cell of multiple filters filter by all of them
                elseif iscell(filters{i}{2})
                    for j= 1:length(filters{i}{2})
                        if ischar(filters{i}{2}{j})        
                            if j == 1
                                I_temp = strcmp(data,filters{i}{2}{j});  
                            else
                                I_temp = I_temp | strcmp(data,filters{i}{2}{j});       
                            end       
                        end
                    end
                    I = I & I_temp;
                end                                 
            % check if numeric    
            elseif isnumeric(DataStruct(1).(fieldname))
                data = [DataStruct.(fieldname)];
                % if filter numeric filter for each item in array
                if isnumeric(filters{i}{2}) && ~isempty(filters{i}{2})
                    filts = filters{i}{2};
                    I_temp = zeros(size(data));
                    for j= 1:length(filts)
                        if isnan(filts(j))
                            I_temp = I_temp | isnan(data);
                        else
                            I_temp = I_temp | data == filts(j);  
                        end
                    end
                    I = I & I_temp;
                elseif iscell(filters{i}{2})
                    if strcmp(filters{i}{2}{1},'range')
                        if isnumeric(filters{i}{2}{2}) && length(filters{i}{2}{2}) == 2
                            bounds = filters{i}{2}{2};
                            I = I & (data >= bounds(1) & data <= bounds(2));
                        end
                    elseif strcmp(filters{i}{2}{1},'contains')
                        if ischar(filters{i}{2}{2})
                            I = I & contains(data,filters{i}{2}{2});
                        end
                    elseif strcmp(filters{i}{2}{1},'tol')
                        if isnumeric(filters{i}{2}{2}) && isnumeric(filters{i}{2}{3})
                            val = filters{i}{2}{2};
                            tol = filters{i}{2}{3};
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
                if isenum(filters{i}{2}) && ~isempty(filters{i}{2})
                    filts = filters{i}{2};
                    I_temp = zeros(size(data));
                    for j= 1:length(filts)
                        I_temp = I_temp | data == filts(j);                    
                    end
                    I = I & I_temp;
                end
            elseif islogical(DataStruct(1).(fieldname))
                data = [DataStruct.(fieldname)];
                if islogical(filters{i}{2}) || isnumeric(filters{i}{2})
                    I = I & (data == filters{i}{2});
                end
            else
                warning('Skipping field %s, as the 1st row is an unknown data type',fieldname);
            end
        end
        
    end   
end
FiltData = DataStruct(I);
end
