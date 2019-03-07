%% Importing, assembling and normalizing 505 EEMF data 

filetype=1; 
ext = 'dat'; 
RangeIn='A17..DN128'; 
headers=[0 1]; 
display_opt=0;
outdat=1;
[X,Emmat,Exmat,filelist_eem,outdata]=readineems(filetype,ext,RangeIn,headers,display_opt,outdat);
nb_sample=size(X,1);
sample_labels=cell(1,nb_sample);
for f = 1:nb_sample
    name=strsplit(filelist_eem(f,:),'.');
    sample_labels(1,f)=name(1);
end

X=X(:,:,end:-1:1);
Ex=Exmat(1,end:-1:1)'; % Inverse Excitation
Em=Emmat(:,1);
mydata=assembledataset(X,Ex,Em,'RU');
mydata0=mydata; % Backup no normalized data 
mydata=normeem(mydata); 

%% Building 2->7 component models by 20 replicates of random initiation:

[LSmodel2,convg2,DSit2]=randinitanal(mydata,2,20,'nonnegativity',1e-8); 
[LSmodel3,convg3,DSit3]=randinitanal(mydata,3,20,'nonnegativity',1e-8); 
[LSmodel4,convg4,DSit4]=randinitanal(mydata,4,20,'nonnegativity',1e-8); 
[LSmodel5,convg5,DSit5]=randinitanal(mydata,5,20,'nonnegativity',1e-8); 
[LSmodel6,convg6,DSit6]=randinitanal(mydata,6,20,'nonnegativity',1e-8); 
[LSmodel7,convg7,DSit7]=randinitanal(mydata,7,20,'nonnegativity',1e-8); 
%too many plots?
close all

%% Three-step Model Validation 

% Step A: Model preselection by core consistency:

plot([2,3,4,5,6,7],[LSmodel2.Model2core,LSmodel3.Model3core,LSmodel4.Model4core,LSmodel5.Model5core,LSmodel6.Model6core,LSmodel7.Model7core],'k*-')
xlabel('Number of components'), ylabel('Core consistency %')

% Outcome: 2 to 7 component models all have a positive core-consistency

% Step B: Monitoring peak locations

for i=2:7
    eval(['loc= describecomp(LSmodel' num2str(i) ',' num2str(i),');']);
    Em_list=[];Ex_list=[];Comp_Em_list=[];Comp_Ex_list=[];Comp_Em_list2=[];Comp_Ex_list2=[];
    for j=1:i
        Em=loc{1,j};
        Em_max=Em(Em(:,2)>=0.1,1);
        Ex=loc{2,j};
        Ex_max=Ex(Ex(:,2)>=0.1,1);
        Em_list=[Em_list;Em_max];
        Ex_list=[Ex_list;Ex_max];
        Comp_Em_list=[Comp_Em_list;repmat(i,size(Em_max,1),1)];
        Comp_Ex_list=[Comp_Ex_list;repmat(i,size(Ex_max,1),1)];
        Comp_Em_list2=[Comp_Em_list2;repmat(j,size(Em_max,1),1)];
        Comp_Ex_list2=[Comp_Ex_list2;repmat(j,size(Ex_max,1),1)];
        
        plot(Comp_Em_list,Em_list,'w+')
        text(Comp_Em_list,Em_list,num2str(Comp_Em_list2),'Color','red');
        hold on
        plot(Comp_Ex_list,Ex_list,'w+');
        text(Comp_Ex_list,Ex_list,num2str(Comp_Ex_list2),'Color','blue');
    end
end
xlabel('Number of components'), ylabel('Peak locations')

% Outcome: The 5-component model should not contain excess component(s) and was selected as the “largest non-overfitted model”.

% Step C: Split half validation for the 5-component model

LSmodel5r=normeem(LSmodel5,'reverse',5);
mydataS1=splitds(mydata,[],4,'alternating',{[1 2],[3 4],[1 3],[2 4],[1 4],[2 3]});
LSmodel5_sp=splitanalysis(mydataS1,5,'nonnegativity',10,1e-8); 
val5=splitvalidation(LSmodel5_sp,5,[1 2;3 4;5 6],{'AB','CD','AC','BD','AD','BC'},LSmodel5r);

% Outcome: The 5-component model was split-half validated
