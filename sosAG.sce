clear;
clc;
npop=1000;
pop=[];
rmin=0;
rmax=10;
bestpop=0;
bestcusto=0;
for i=1:npop
    pop(i)=rand()*(rmax-rmin)+rmin;
end

for epoca=1:1000
custo=[];
for i=1:npop
    //custo(i)=exp(-1/20*(17-pop(i))^2);
    custo(i)=pop(i)/2*(1-2*%pi*pop(i));
end

for i=1:npop
if custo(i)>bestcusto then
  bestpop=pop(i);
  bestcusto=custo(i);
  altura=(1-2*%pi*bestpop)/(2*%pi*bestpop);
  disp(bestpop);
  disp(altura);
  disp(bestcusto);
  
end
end


//Torneio




newpopx=[];
for i=1:npop
    t1=0;
    t2=0;
    while t1==t2
      t1=round(rand()*(npop-1))+1;
      t2=round(rand()*(npop-1))+1;     
    end
    if pop(t1)>pop(t2) then
      newpopx(i)=pop(t1);
  else
      newpopx(i)=pop(t2); 
    end 
end




newpopy=[];
for i=1:npop
    t1=0;
    t2=0;
    while t1==t2
      t1=round(rand()*(npop-1))+1;
      t2=round(rand()*(npop-1))+1;     
    end
    if pop(t1)>pop(t2) then
      newpopy(i)=pop(t1);
  else
      newpopy(i)=pop(t2); 
    end 
end
//Crossover
newpop=[];
for i=1:npop
    newpop(i)=sqrt(newpopy(i)*newpopx(i));
end
//mutação
for i=1:npop
    if rand()>=0.7 then
      newpop(i)=rand()*(rmax-rmin)+rmin;
    end
end
//
pop=newpop;
pop(1)=bestpop;
end



