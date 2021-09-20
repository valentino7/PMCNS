function generateEquationMarkovAlg2()

n = 11;

la = 1.5;
lb = 1.8;
ma = 0.2;
mb = 0.15;

ta = 1/ma ;
tb = 1/mb ;

limit = 11;

mAc= 0.11;
mBc = 0.08;

tAc = 1/mAc;
tBc = 1/mBc;

dim2 = zeros(1, ( (limit)*(limit+1)/2 )+ limit*(n-limit) );
states = string(dim2);
variable = zeros(length(dim2),2);
equations = sym(dim2);
count= 1;

%Costruzione delle equazioni
for layers = 1:n
    
    i = layers - 1;
    j = 0;
    if ( layers<limit )
        for k = 1:layers
            if i == 0
                b1 = 0;
            else
                b1 = 1;
            end
            if j == 0
                b2 = 0;
            else
                b2 = 1;
            end
            if layers == n
                a = 0;
            else
                a = 1;
            end
            
            str = 'p'+string(i)+'o'+string(j);
            variable(count,1) = i;
            variable(count,2) = j;
            str = sym(str);
            if ( a ~= 0 )
                str1 = 'p'+string(i+1)+'o'+string(j);
                str2 = 'p'+string(i)+'o'+string(j+1);
                str1 = sym(str1);
                str2 = sym(str2);
            else
                str1 = sym('init');
                str2 = sym('init');
                
            end
            if ( b1 ~= 0 )
                str3 = 'p'+string(i-1)+'o'+string(j);
                str3 = sym(str3);
            else
                str3 = sym('init');
            end
            if ( b2 ~= 0 )
                str4 = 'p'+string(i)+'o'+string(j-1);
                str4 = sym(str4);
            else
                str4 = sym('init');
            end
            %eq = sym (str* (c *(la + lb) +(~c)*(la) + i*ma + j*mb ) - a*str1*(i + 1)*ma - c*a*str2*(j + 1)*mb - b1*str3*la - c*b2*str4*lb  == 0)
            equations(count) = sym (str* (a *(la + lb) + i*ma + j*mb ) - a*str1*(i + 1)*ma - a*str2*(j + 1)*mb - b1*str3*la - b2*str4*lb  == 0);
            states(count)= str;
            
            
            count=count+1;
            i=i-1;
            j=j+1;
        end
    elseif (layers>limit)
        for k = 1:limit
            if i == 0
                b1 = 0;
            else
                b1 = 1;
            end
            if (i+j+1) == n
                a = 0;
            else
                a = 1;
            end
            if j == limit-1
                c = 0;
            else
                c = 1;
            end
            str = 'p'+string(i)+'o'+string(j);
            variable(count,1) = i;
            variable(count,2) = j;
            str = sym(str);
            if ( a ~= 0 )
                str1 = 'p'+string(i+1)+'o'+string(j);
                str2 = 'p'+string(i)+'o'+string(j+1);
                str1 = sym(str1);
                str2 = sym(str2);
            else
                str1 = sym('init');
                str2 = sym('init');
                
            end
            if ( b1 ~= 0 )
                str3 = 'p'+string(i-1)+'o'+string(j);
                str3 = sym(str3);
            else
                str3 = sym('init');
            end
            %eq = sym (str* (c *(la + lb) +(~c)*(la) + i*ma + j*mb ) - a*str1*(i + 1)*ma - c*a*str2*(j + 1)*mb - b1*str3*la - c*b2*str4*lb  == 0)
            equations(count) = sym ( str*(a *la + i*ma + j*mb ) - a*str1*(i + 1)*ma - c*a*str2*(j + 1)*mb - b1*str3*la == 0);
            states(count)= str;
            
            
            count=count+1;
            i=i-1;
            j=j+1;
        end
    else
        for k = 1:limit
            if i == 0
                b1 = 0;
            else
                b1 = 1;
            end
            if j == 0
                b2 = 0;
            else
                b2 = 1;
            end
            if (i+j+1) == n
                a = 0;
            else
                a = 1;
            end
            if j == limit-1
                c = 0;
            else
                c = 1;
            end
            str = 'p'+string(i)+'o'+string(j);
            variable(count,1) = i;
            variable(count,2) = j;
            str = sym(str);
            if ( a ~= 0 )
                str1 = 'p'+string(i+1)+'o'+string(j);
                str2 = 'p'+string(i)+'o'+string(j+1);
                str1 = sym(str1);
                str2 = sym(str2);
            else
                str1 = sym('init');
                str2 = sym('init');
                
            end
            if ( b1 ~= 0 )
                str3 = 'p'+string(i-1)+'o'+string(j);
                str3 = sym(str3);
            else
                str3 = sym('init');
            end
            if ( b2 ~= 0 )
                str4 = 'p'+string(i)+'o'+string(j-1);
                str4 = sym(str4);
            else
                str4 = sym('init');
            end
            %eq = sym (str* (c *(la + lb) +(~c)*(la) + i*ma + j*mb ) - a*str1*(i + 1)*ma - c*a*str2*(j + 1)*mb - b1*str3*la - c*b2*str4*lb  == 0)
            equations(count) = sym ( str*(a *la + i*ma + j*mb ) - a*str1*(i + 1)*ma - c*a*str2*(j + 1)*mb - b1*str3*la - b2*str4*lb == 0);
            states(count)= str;
            
            
            count=count+1;
            i=i-1;
            j=j+1;
        end
    end
end
states = sym(states);



%Sostituzione dell' equazione degli stati che sommano a 1 all'ultima
%equazione

count=count-1;
equations(count) = states(1);
for i = 2:count
    equations(count) = equations(count) + states(i) ;
end
equations(count) = equations(count) - 1== 0;

%disp(x);


%%
%Risoluzione delle equazioni
format long g;
[A,b] = equationsToMatrix(equations,states);
X = linsolve(A,b);
Y = double(X);


%%
%somma delle probabilit√† degli stati dell'ultimo layer
pq =0;
pq_1 =0;
pq_2 =0;
count= (limit*(limit-1) /2)+1;
%names = cell(11*(n-limit),2);
l=1;
for layers = limit:n
    for k = 1:limit
        %i = variable(count+k-1,1);
        %j = variable(count+k-1,2);
        %names{l,1} = 'p'+string(i)+'o'+string(j);
        if layers == n
            %names{l,2} = 'la+lb';
            pq_1 = pq_1 + la*Y(count+k-1); 
            pq_2 = pq_2 + lb*Y(count+k-1);
            pq = pq + (la+lb)*Y(count+k-1);           
        else
            %names{l,2} = 'lb';
            pq_2 = pq_2 + lb*Y(count+k-1);
            pq = pq + lb*Y(count+k-1);
        end
        l=l+1;
    end
    count=count+k;
end
pq = pq / (la+lb) ;

%fprintf('probabilit‡ di blocco %f\n',pq);
%fprintf('probabilit‡ di blocco pq_1 %f\n',pq_1);
%fprintf('probabilit‡ di blocco pq_2 %f\n',pq_2);

%%
s = 0;
s1 = 0;
s2 = 0;
count= 2;
for layers = 2:n
    if (layers < limit)
        for k = 1:layers
            i = variable(count+k-1,1);
            j = variable(count+k-1,2);
            s = s +(layers)*Y(count+k-1);  % somma( n*p(i,j))
            s1 = s1 + i *Y(count+k-1);
            s2 = s2 + j *Y(count+k-1);
        end
    else
        for k = 1:limit
            i = variable(count+k-1,1);
            j = variable(count+k-1,2);
            s = s +(i+j)*Y(count+k-1);  % somma( n*p(i,j))
            s1 = s1 + i *Y(count+k-1);
            s2 = s2 + j *Y(count+k-1);
        end
    end
    count=count+k;
end

% E[T]_serverfarm = sum(n(i,j)*p(i,j)) per ogni i, per ogni j
% E[T]_serverfarm_type1 = sum(n1(i,j)*p(i,j) per ogni i, per ogni j
% E[T]_serverfarm_type2 = sum(n2(i,j)*p(i,j) per ogni i, per ogni j
clc
p1_cloud = (la*pq_1)/ (pq*(la+lb));
p2_cloud = 1-p1_cloud;

p1_serverfarm = (la*(1-pq_1))/ ((1-pq)*(la+lb));
p2_serverfarm = 1-p1_serverfarm;

L_clet = (1-pq)*(la+lb);
L1_clet = (1-pq_1)*(la);
L2_clet = (1-pq_2)*(lb);

L_cloud = (pq)*(la+lb);
L1_cloud = (pq_1)*(la);
L2_cloud = (pq_2)*(lb);

L_s = L_clet + L_cloud ;
L1_s = L1_clet + L1_cloud;
L2_s = L2_clet + L2_cloud;


disp("pq: "+pq);
disp("pq_1: "+pq_1);
disp("pq_2: "+pq_2);

disp("p1 serverfarm: "+p1_serverfarm);
disp("p2 serverfarm: "+p2_serverfarm);
disp("p1 cloud: "+p1_cloud);
disp("p2 cloud: "+p2_cloud);


T_serverfarm = p1_serverfarm*ta +p2_serverfarm*tb; % serverfarm
T1_serverfarm = ta; % serverfarm
T2_serverfarm = tb; % serverfarm

T_CLOUD = (p1_cloud*tAc + p2_cloud*tBc) ; % cloud
T1_CLOUD = tAc; % cloud
T2_CLOUD = tBc; % cloud

T_SISTEMA = (1-pq)*T_serverfarm+ pq*T_CLOUD; %sistema
T1_SISTEMA = (1-pq_1)*T1_serverfarm+pq_1*T1_CLOUD; %sistema
T2_SISTEMA =(1-pq_2)*T2_serverfarm+pq_2*T2_CLOUD; %sistema

N_cloud = L_cloud*T_CLOUD;
N1_cloud = L1_cloud*T1_CLOUD;
N2_cloud = L2_cloud*T2_CLOUD;

N_serverfarm = L_clet*T_serverfarm;
N1_serverfarm = L1_clet*T1_serverfarm;
N2_serverfarm = L2_clet*T2_serverfarm;

N_sistema = N_serverfarm +N_cloud;
N1_sistema = N1_serverfarm +N1_cloud;
N2_sistema = N2_serverfarm +N2_cloud;

cell_time = {};
cell_num = {};
cell_throghput = {};

cell_time{1,1} = "E[T]_serverfarm";
cell_time{1,2} = T_serverfarm;
cell_time{2,1} = "E[T1]_serverfarm";
cell_time{2,2} = T1_serverfarm;
cell_time{3,1} = "E[T2]_serverfarm";
cell_time{3,2} = T2_serverfarm;

cell_time{4,1} = "E[T]_CLOUD";
cell_time{4,2} = T_CLOUD;
cell_time{5,1} = "E[T1]_CLOUD";
cell_time{5,2} = T1_CLOUD;
cell_time{6,1} = "E[T2]_CLOUD";
cell_time{6,2} = T2_CLOUD;

cell_time{7,1} = "E[T]_SISTEMA";
cell_time{7,2} = T_SISTEMA;
cell_time{8,1} = "E[T1]_SISTEMA";
cell_time{8,2} = T1_SISTEMA;
cell_time{9,1} = "E[T2]_SISTEMA";
cell_time{9,2} = T2_SISTEMA;

cell_num{1,1} = "E[N]_serverfarm";
cell_num{1,2} = N_serverfarm;
cell_num{2,1} = "E[N1]_serverfarm";
cell_num{2,2} = N1_serverfarm;
cell_num{3,1} = "E[N2]_serverfarm";
cell_num{3,2} = N2_serverfarm;

cell_num{4,1} = "E[N]_CLOUD";
cell_num{4,2} = N_cloud;
cell_num{5,1} = "E[N1]_CLOUD";
cell_num{5,2} = N1_cloud;
cell_num{6,1} = "E[N2]_CLOUD";
cell_num{6,2} = N2_cloud;

cell_num{7,1} = "E[N]_SISTEMA";
cell_num{7,2} = N_sistema;
cell_num{8,1} = "E[N1]_SISTEMA";
cell_num{8,2} = N1_sistema;
cell_num{9,1} = "E[N2]_SISTEMA";
cell_num{9,2} = N2_sistema;

cell_throghput{1,1} = "L_serverfarm";
cell_throghput{1,2} = L_clet;
cell_throghput{2,1} = "L1_serverfarm";
cell_throghput{2,2} = L1_clet;
cell_throghput{3,1} = "L2_serverfarm";
cell_throghput{3,2} = L2_clet;

cell_throghput{4,1} = "L_CLOUD";
cell_throghput{4,2} = L_cloud;
cell_throghput{5,1} = "L1_CLOUD";
cell_throghput{5,2} = L1_cloud;
cell_throghput{6,1} = "L2_CLOUD";
cell_throghput{6,2} = L2_cloud;

cell_throghput{7,1} = "L_SISTEMA";
cell_throghput{7,2} = L_s;
cell_throghput{8,1} = "L1_SISTEMA";
cell_throghput{8,2} = L1_s;
cell_throghput{9,1} = "L2_SISTEMA";
cell_throghput{9,2} = L2_s;

filename = 'result5.xlsx';
sheet = 2;
tlRange = 'A1:A9';
t2Range = 'B1:B9';

n1Range = 'A11:A19';
n2Range = 'B11:B19';

l1Range = 'A21:A29';
l2Range = 'B21:B29';

xlswrite(filename,[cell_time{:,1}]',sheet,tlRange);
xlswrite(filename,[cell_time{:,2}]',sheet,t2Range);

xlswrite(filename,[cell_num{:,1}]',sheet,n1Range);
xlswrite(filename,[cell_num{:,2}]',sheet,n2Range);

xlswrite(filename,[cell_throghput{:,1}]',sheet,l1Range);
xlswrite(filename,[cell_throghput{:,2}]',sheet,l2Range);

end



