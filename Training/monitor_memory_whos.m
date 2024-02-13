function [memory_in_use] = monitor_memory_whos()
% MONITOR_MEMORY_WHOS uses the WHOS command to evaluate the memory usage
% inside the base workspace. It calculates and returns the total memory
% usage in gigabytes (GB).

% Get information about variables in the base workspace
mem_elements = evalin('base', 'whos');

% Check if there are variables in the base workspace
if size(mem_elements, 1) > 0
    % Extract the size in bytes for each variable
    memory_array = [mem_elements.bytes];

    % Calculate the total memory usage in bytes
    memory_in_use = sum(memory_array);

    % Convert memory usage to gigabytes (GB)
    memory_in_use = memory_in_use / (1024 * 1024 * 1024);
else
    % If there are no variables, set memory usage to 0 GB
    memory_in_use = 0;
end
