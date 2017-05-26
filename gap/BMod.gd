#
# BMod: Monoidal categories of modules over bialgebras
#
# Declarations
#

#! @Chapter Monoidal category of modules over a bialgebra

# our info class:
DeclareInfoClass( "InfoCategoriesWithBialgebraActions" );
SetInfoLevel( InfoCategoriesWithBialgebraActions, 1 );

####################################
#
#! @Section Categories
#
####################################

#! @Description
#!  The &GAP; category of objects with bialgbra action in a &CAP; category.
DeclareCategory( "IsCapCategoryObjectWithBialgebraAction",
        IsCapCategoryObject );

#! @Description
#!  The &GAP; category of morphisms between objects with bialgbra actions in a &CAP; category.
DeclareCategory( "IsCapCategoryMorphismWithBialgebraAction",
        IsCapCategoryMorphism );

####################################
#
#! @Section Technical stuff
#
####################################

# a central place for configurations:
DeclareGlobalVariable( "PROPAGATION_LIST_FOR_MORPHISMS_BETWEEN_OBJECTS_WITH_BIALGEBRA_ACTION" );

DeclareGlobalFunction( "INSTALL_TODO_LIST_FOR_MORPHISMS_BETWEEN_OBJECTS_WITH_BIALGEBRA_ACTIONS" );

####################################
#
#! @Section Attributes
#
####################################

#! @Description
#!  The dimension of the underlying vector space.
#! @Arguments M
#! @Returns an integer
DeclareAttribute( "Dimension",
        IsCapCategoryObjectWithBialgebraAction );

#! @Description
#!  The $k$-vector space underlying the D-module map <A>phi</A>.
#! @Arguments M
#! @Returns a &CAP; object
DeclareAttribute( "UnderlyingCell",
        IsCapCategoryObjectWithBialgebraAction );

#! @Description
#!  The $k$-vector space map underlying the D-module map <A>phi</A>.
#! @Arguments M
#! @Returns a list (of &CAP; morphisms)
DeclareAttribute( "ActionEndomorphisms",
        IsCapCategoryObjectWithBialgebraAction );

#! @Description
#!  The $k$-vector space map underlying the D-module map <A>phi</A>.
#! @Arguments phi
#! @Returns a &CAP; morphism
DeclareAttribute( "UnderlyingCell",
        IsCapCategoryMorphismWithBialgebraAction );

####################################
#
#! @Section Constructors
#
####################################

DeclareGlobalFunction( "ADD_FUNCTIONS_FOR_CATEGORY_WITH_BIALGEBRA_ACTION" );

#! @Description
#!  The constructor of the category of D-modules modeled over the category
#!  <A>A</A> of finite dimensional $k$-vector spaces.
#!  The list <A>attr</A> specifies the $k$-bialgebra.
#! @Arguments A, bialgebra
#! @Returns a &CAP; category
DeclareOperation( "CategoryWithBialgebraAction",
        [ IsCapCategory, IsList ] );

#! @Description
#!  Create a finite dimensional $k$-vector space over equipped with an action
#!  of a $k$-bialgebra, where $k$ is a field.
#!  The action is given by the action endomorphisms listed in <A>L</A>.
#!  We refer to such a module as D-module.
#! @Arguments L, B
#! @Returns a &CAP; object
DeclareOperation( "BMod",
        [ IsList, IsCapCategory ] );

#! @Description
#!  Create the morphism with source D-module <A>S</A> and target D-module <A>T</A>
#!  given by the $k$-linear map <A>phi</A> between the underlying
#!  finite dimensional $k$-vector spaces.
#! @Arguments S, phi, T
#! @Group BMod_morphism
#! @Returns a &CAP; morphism
DeclareOperation( "BMod",
        [ IsCapCategoryObjectWithBialgebraAction, IsCapCategoryMorphism, IsCapCategoryObjectWithBialgebraAction ] );

#! @Arguments S, mat, T
#! @Group BMod_morphism
#! @Returns a &CAP; morphism
DeclareOperation( "BMod",
        [ IsCapCategoryObjectWithBialgebraAction, IsHomalgMatrix, IsCapCategoryObjectWithBialgebraAction ] );

#! @Description
#!  Wrap the &CAP; functor <A>F</A>:<C>UnderlyingCategory</C>(<A>A</A>)<M>\to</M><C>UnderlyingCategory</C>(<A>B</A>),
#!  where <A>A</A> and <A>B</A> are categories with bialgbra actions.
#! @Arguments F, name, A, B
#! @Group BMod_functor
#! @Returns a &CAP; functor
DeclareOperation( "BMod",
        [ IsCapFunctor, IsString, IsCapCategory, IsCapCategory ] );

#! @Arguments F, A, B
#! @Group BMod_functor
DeclareOperation( "BMod",
        [ IsCapFunctor, IsCapCategory, IsCapCategory ] );

#! @Arguments F, name, A
#! @Group BMod_functor
DeclareOperation( "BMod",
        [ IsCapFunctor, IsString, IsCapCategory ] );

#! @Arguments F, A
#! @Group BMod_functor
DeclareOperation( "BMod",
        [ IsCapFunctor, IsCapCategory ] );

#! @Description
#!  Wrap the &CAP; natural transformation <A>eta</A>:<A>F</A><C>!.UnderlyingFunctor</C><M>\to</M><A>G</A><C>!.UnderlyingFunctor</C>,
#!  where <A>F</A> and <A>G</A> are functors between categories with bialgbra actions.
#! @Arguments eta, name, F, G
#! @Group BMod_nattr
#! @Returns a &CAP; natural transformation
DeclareOperation( "BMod",
        [ IsCapNaturalTransformation, IsString, IsCapFunctor, IsCapFunctor ] );

#! @Arguments eta, F, G
#! @Group BMod_nattr
DeclareOperation( "BMod",
        [ IsCapNaturalTransformation, IsCapFunctor, IsCapFunctor ] );
