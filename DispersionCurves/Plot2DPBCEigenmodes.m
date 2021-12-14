function Plot2DPBCEigenmodes(coordinates,nodesInitial,nodesPlot,QuadMeshNodes, ...
    factor,depl,component, numEig,f,K,Font,FontSize,axLimits,colMap,PMshStudy) 
%--------------------------------------------------------------------------
% Purpose:
%         To plot the profile of a component on deformed mesh
% Synopsis :
%           ProfileonDefoMesh(coordinates,nodes,component)
% Variable Description:
%           coordinates - The nodal coordinates of the mesh
%           -----> coordinates = [X Y Z] 
%           nodes - The nodal connectivity of the elements
%           -----> nodes = [node1 node2......]    
%           factor - Amplification factor (Change accordingly, trial)
%           depl -  Nodal displacements
%           -----> depl = [UX UY UZ]
%           component - The components whose profile to be plotted
%           -----> components = a column vector in the order of node
%                               numbers
%
%--------------------------------------------------------------------------
%dimension = size(coordinates,2) ;        % Dimension of the mesh
nel = size(nodesInitial,1) ;                     % number of elements
nnode = length(coordinates) ;             % total number of nodes in system
% nnel = size(nodesInitial,2);                     % number of nodes per element
nnel = size(nodesPlot,2);                     % number of nodes per element
% 
% Initialization of the required matrices
X = zeros(nnel,nel) ; UX = zeros(nnel,nel) ;
Y = zeros(nnel,nel) ; UY = zeros(nnel,nel) ;
Z = zeros(nnel,nel) ; UZ = zeros(nnel,nel) ;
profile = zeros(nnel,nel) ;
    ux = depl(:,1) ;
    uy = depl(:,2) ;
    for iel=1:nel   
%         ndinit=nodesInitial(iel,:);         % extract connected node for (iel)-th element
        ndplot=nodesPlot(iel,:);         % extract connected node for (iel)-th element
        X(:,iel)=coordinates(ndplot,1);    % extract x value of the node
        Y(:,iel)=coordinates(ndplot,2);    % extract y value of the node
        
        UX(:,iel) = ux(ndplot') ;
        UY(:,iel) = uy(ndplot') ;
        profile(:,iel) = component(ndplot') ;      
    end
    % Plotting the profile of a property on the deformed mesh
    defoX = X+UX ; %UX*factor
    defoY = Y+UY ;  
%     figure
%     set(gcf, 'Position',  [0, 0, 1920, 1080])
    set(gcf, 'Position',  [0, 0, 2560, 1080])
hold on
    fill(defoX,defoY,profile,'LineStyle','none')
    if PMshStudy==1
    quadmeshTransp(nodesInitial(:,QuadMeshNodes),coordinates(:,1)+depl(:,1), ...
        coordinates(:,2)+depl(:,2),zeros(size(coordinates,1),1));
    end
    hold off
    colormap(colMap)
%     axis on ;
    box on
    daspect([1 1 1]);
    axis(axLimits)
%     set(gca,'Layer','top')
%     title([num2str(numEig),'. Eigenmode, f=',num2str(f,'%.2f'),' [Hz] '])
    if K(1)==0 && K(2)==0
    title([num2str(numEig,'%.0f') '. Eigenmode, $f$ = ' num2str(abs(f),'%.1f') ' [Hz], point $\Gamma$'] , 'FontSize', FontSize);
    end
    if K(1)==pi() && K(2)==0
    title([num2str(numEig,'%.0f') '. Eigenmode, $f$ = ' num2str(abs(f),'%.1f') ' [Hz], point $X$'] , 'interpreter', 'latex', 'FontSize', FontSize);
    end
    if K(1)==pi() && K(2)==pi()
    title([num2str(numEig,'%.0f') '. Eigenmode, $f$ = ' num2str(abs(f),'%.1f') ' [Hz], point $M$'] , 'interpreter', 'latex', 'FontSize', FontSize);
    end
    figureHandle4 = gcf;
    set(findall(figureHandle4,'type','text'),'fontSize',FontSize,'fontWeight','normal','fontName',Font)
    set(findall(figureHandle4,'type','axes'),'fontsize',FontSize,'fontWeight','normal','fontName',Font)
    % Colorbar Setting
    SetColorbar
end