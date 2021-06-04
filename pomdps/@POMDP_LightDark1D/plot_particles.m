function [] = plot_particles(obj, b, t)

%weighted mean f particles
mu=0;
for i=1:length(b.w)
    mu = mu + b.s(i)*b.w(i);
end

%merge particles (i.e., only for illustration purposes)
%if particles share the same state, then merge the particles to visualize
%the actual weight for that particular state
s_merged=[];
w_merged=[];
for i=1:length(b.w)
    s=b.s(i);
    w=b.w(i);
    is_duplicate=false;
    idx_duplicate=[];
    for j=1:length(s_merged)
        if(s == s_merged(j))
            is_duplicate=true;
            idx_duplicate=j;
            break;
        end
    end
    if(~is_duplicate)
        s_merged = [s_merged s];
        w_merged = [w_merged w];
    else
        w_merged(idx_duplicate) = w_merged(idx_duplicate) + w;
    end
end
b.s=s_merged;
b.w=w_merged;
    
%plot merged particles
for i=1:length(b.w)
    hold on;
    
    markersize = 2 + b.w(i)*14;
    markeredgecolor = 'k';
    markerfacecolor = [0.0, 0.4, 0.75];
    
    plot(t, b.s(i),...
         'o',...
         'MarkerEdgeColor',markeredgecolor,...
         'MarkerFaceColor',markerfacecolor,...
         'MarkerSize',markersize);
end

%plot weighted mean of particles
hold on;
plot(t,mu,'gx');

end

