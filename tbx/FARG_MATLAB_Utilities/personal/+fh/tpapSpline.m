classdef tpapSpline
    %TPAPSPLINE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Nmodes
        sts
        n
        V
        p
    end
    
    methods
        function obj = tpapSpline(Xs,res_modeshape,GIDs,N_modes,smoothParam)
            arguments
                Xs
                res_modeshape
                GIDs
                N_modes
                smoothParam = [];
            end
            %TPAPSPLINE Construct an instance of this class
            %   Detailed explanation goes here
            [obj.n,obj.V,obj.p] = farg.geom.affineFit(Xs');
            Xs_2d = obj.get_projection(Xs);

            idx = ismember(res_modeshape(1).IDs,GIDs);
            obj.sts = {};
            cnt = 1;
            for i = N_modes
                e_vec = res_modeshape(i).EigenVector(idx,:)';
%                 e_vec = [res_modeshape(i).EigenVector(:,idx(i,:));res_modeshape.T2(i,idx(i,:));res_modeshape.T3(i,idx(i,:));...
%                     res_modeshape.R1(i,idx(i,:));res_modeshape.R2(i,idx(i,:));res_modeshape.R3(i,idx(i,:))];
                obj.sts{cnt} = tpaps(Xs_2d,e_vec,smoothParam);
                cnt = cnt + 1;
            end
            obj.Nmodes = N_modes;
        end
        
        function Xs_2d = get_projection(obj,Xs,opts)
            arguments
                obj
                Xs
                opts.C double =0.12
            end
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            Np = size(Xs,2);
            X_zero = Xs-repmat(obj.p',1,Np);
%             Xs_proj = Xs - n*dot(Xs-repmat(obj.p',1,Np),repmat(obj.n,1,Np));
            Xs_2d = [dot(X_zero,repmat(obj.V(:,1),1,Np));dot(X_zero,repmat(obj.V(:,2),1,Np))];
        end

        function G = get_G(obj,Xs,DoFs,idx)
            if numel(idx)~=numel(obj.Nmodes)
                error('length of idx must equal number of modes')
            end
            Xs_2d = obj.get_projection(Xs);
            G = zeros(6,DoFs,size(Xs,2));
%             G = zeros(6,numel(obj.Nmodes),size(Xs,2));
            for i = 1:numel(obj.Nmodes)
                Gtmp = fnval(obj.sts{i},Xs_2d);
                for j = 1:size(Xs,2)
                    G(:,idx(i),j) = Gtmp(:,j);
                end
            end
        end

    end
end


