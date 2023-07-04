function nodes= wt_nodes()
nodes = fh.wt.octagon_nodes(1.524,2.1336,x_fillet=0.885/2,y_fillet=0.740/2,origin=[-2.1336/2,-1.524/2]);
nodes = [nodes;nodes(1,:)];
end

