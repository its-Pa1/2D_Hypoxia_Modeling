function [loss, loss_worst,ParamTable] = post_processing(X,all_minimums,sample_str,dx, hypoxia_data,V, ...
    O2, hypoxia_calculated,hypo_model_type,additionStr)

% POST_PROCESSING performs post-processing for each patch simulation.

% INPUT:
%   X: x-interval of the domain.
%   all_minimums: Loss function values from the optimizer.
%   sample_str: Patch name.
%   dx: Spatial step length.
%   hypoxia_data: Density obtained from the images of CA9 scan.
%   V: Blood vessel density obtained from the images of CD31 scan.
%   O2: Solution for O2 on the discretized points.
%   hypoxia_calculated: Hypoxia calculated using the model.
%   hypo_model_type: Type of the hypoxia model.
%   additionStr: Additional string for naming.

% OUTPUT:
%   loss: Value of the loss function minimized by the optimizer.
%   loss_worst: Value of the loss function in the worst-case scenario.
%   ParamTable: Table containing parameter values.



%% --------------- save and export the parameter ranges -----------------
% export the optimal values and the intervals in .txt and .tex files

y = arrayfun(@(x)x.Fval,all_minimums);

y_1 = y(1)*1.5;

ii = 1;
for j = 1:size(y,2)
    if y(j)<=y_1
        index(ii) = j;
        ii = ii+1;
    end
end


%% ------------------------ worst case comparison -------------------
% creating random values for the hypoxia and taking a mean

hypoxia_worst = rand(50,size(X,1)*size(X,2));
hypoxia_worst = mean(hypoxia_worst);
hypoxia_worst = reshape(hypoxia_worst,size(X,1),size(X,2));

hypoxia_worst = hypoxia_worst(1:dx:end,1:dx:end);
hypoxia_data = hypoxia_data(1:dx:end,1:dx:end);
hypoxia_data = hypoxia_data/(max(eps, max(hypoxia_data(:))));

V = V(1:dx:end,1:dx:end);
V = V/(max(eps, max(V(:))));


fvals = arrayfun(@(x)x.Fval,all_minimums);
loss = min(fvals)/sqrt(size(X,1)*size(X,2));
% loss = ((norm(hypoxia_calculated - hypoxia_data))^2)/sqrt(size(x,2)*size(y,2));
loss_worst = ((norm(hypoxia_worst - hypoxia_data))^2)/sqrt(size(X,1)*size(X,2));




%% ---------------------------------------------

switch hypo_model_type

    case 'linear_expo'
        alpha = arrayfun(@(x)x.X(1),all_minimums);
        beta = arrayfun(@(x)x.X(2),all_minimums);
        gamma = arrayfun(@(x)x.X(3),all_minimums);
        O_l = arrayfun(@(x)x.X(4),all_minimums);
        O_h = arrayfun(@(x)x.X(5),all_minimums);
        k1 = arrayfun(@(x)x.X(6),all_minimums);
        D_h = arrayfun(@(x)x.X(7),all_minimums);
        %k2 = arrayfun(@(x)x.X(8),all_minimums);
        %k3 =arrayfun(@(x)x.X(9),all_minimums);
        temp_table = table;
        temp_table.SampleName = sample_str;
        temp_table.D = D_h(1);
        temp_table.alpha = alpha(1);
        temp_table.beta = beta(1);
        temp_table.gamma = gamma(1);
        temp_table.k1 = k1(1);
        temp_table.k2 = NaN;
        temp_table.k3 = NaN;
        temp_table.Ol = O_l(1);
        temp_table.Oh = O_h(1);


        temp_table.D_int = [min(D_h(index)), max(D_h(index))];
        temp_table.alpha_int = [min(alpha(index)), max(alpha(index))];
        temp_table.beta_int = [min(beta(index)), max(beta(index))];
        temp_table.gamma_int = [min(gamma(index)), max(gamma(index))];
        temp_table.k1_int = [min(k1(index)), max(k1(index))];
        temp_table.k2_int = [NaN, NaN];
        temp_table.k3_int = [NaN, NaN];
        temp_table.Ol_int = [  min(O_l(index)), max(O_l(index))];
        temp_table.Oh_int = [min(O_h(index)), max(O_h(index))];

        temp_table.loss = loss;
        temp_table.loss_worst = loss_worst;
        temp_table.dx = dx;




        tableFolderName = strcat('ExportTables_expo', additionStr);
        tableFileName = strcat('EstimatedParamTable',hypo_model_type, additionStr, '.mat');
        tableFullFileName = fullfile(tableFolderName,tableFileName);

        if not(isfolder(tableFolderName))
            mkdir(tableFolderName)
        end
        % TableFileName = strcat('ExportTables_expo/',sample_str, '_sol');

        if ~exist(tableFullFileName,"file")

            ParamTable = table;
            ParamTable = [ParamTable;temp_table];

        else

            load(tableFullFileName,'ParamTable');
            ParamTable = [ParamTable;temp_table];


        end
        save(tableFullFileName,"ParamTable");


    case 'linear_gen'

        alpha = arrayfun(@(x)x.X(1),all_minimums);
        beta = arrayfun(@(x)x.X(2),all_minimums);
        gamma = arrayfun(@(x)x.X(3),all_minimums);
        O_l = arrayfun(@(x)x.X(4),all_minimums);
        O_h = arrayfun(@(x)x.X(5),all_minimums);
        k1 = arrayfun(@(x)x.X(6),all_minimums);
        D_h = arrayfun(@(x)x.X(7),all_minimums);
        k2 = arrayfun(@(x)x.X(8),all_minimums);
        k3 =arrayfun(@(x)x.X(9),all_minimums);



        temp_table = table;
        temp_table.SampleName = sample_str;
        temp_table.D = D_h(1);
        temp_table.alpha = alpha(1);
        temp_table.beta = beta(1);
        temp_table.gamma = gamma(1);
        temp_table.k1 = k1(1);
        temp_table.k2 = k2(1);
        temp_table.k3 = k3(1);
        temp_table.Ol = O_l(1);
        temp_table.Oh = O_h(1);


        temp_table.D_int = [min(D_h(index)), max(D_h(index))];
        temp_table.alpha_int = [min(alpha(index)), max(alpha(index))];
        temp_table.beta_int = [min(beta(index)), max(beta(index))];
        temp_table.gamma_int = [min(gamma(index)), max(gamma(index))];
        temp_table.k1_int = [min(k1(index)), max(k1(index))];
        temp_table.k2_int = [min(k2(index)), max(k2(index))];
        temp_table.k3_int = [ min(k3(index)), max(k3(index))];
        temp_table.Ol_int = [  min(O_l(index)), max(O_l(index))];
        temp_table.Oh_int = [min(O_h(index)), max(O_h(index))];

        temp_table.loss = loss;
        temp_table.loss_worst = loss_worst;
        temp_table.dx = dx;



        if not(isfolder('ExportTables_gen'))
            mkdir('ExportTables_gen')
        end
        % TableFileName = strcat('ExportTables_gen/',sample_str, '_sol');

        if ~exist("ExportTables_gen/EstimatedParamTable.mat","file")
            ParamTable = table;
            ParamTable = [ParamTable;temp_table];

        else
            load('ExportTables_gen/EstimatedParamTable.mat','ParamTable');
            ParamTable = [ParamTable;temp_table];
            %ParamTable = outerjoin(ParamTable,ROWS2VARS(temp_table));


        end
        save('ExportTables_gen/EstimatedParamTable.mat',"ParamTable");

    case 'nonlinear'
        fprintf('Nonlinear post-processing is not done yet!');
end

% TableFileName_tex = convertStringsToChars(strcat('ExportTables/',sample_str, '_sol'));
% T2 = table(ParamOptValue,ParamMin,ParamMax);                              %
% T2.Properties.RowNames = ParamNames;                                 %
% table2latex(T2, TableFileName_tex);


sz1 = size(X,1);
sz2 = size(X,2);

%% -------------------------- save the workspace ------------------------
wFolder = strcat('EstiParams',hypo_model_type, additionStr);
if not(isfolder(wFolder))
    mkdir(wFolder)
end

SimDataFineName = strcat(wFolder,'/',sample_str,'_', hypo_model_type,additionStr);
save (SimDataFineName, "sample_str", 'V',"O2", "hypoxia_data", "hypoxia_calculated","all_minimums","dx", "sz1", "sz2");


