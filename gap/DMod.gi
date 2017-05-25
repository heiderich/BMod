#
# DMod: Monoidal categories of modules over bialgebras
#
# Implementations
#

####################################
#
# representations:
#
####################################

DeclareRepresentation( "IsCapCategoryObjectWithBialgebraActionRep",
        IsCapCategoryObjectWithBialgebraAction and
        IsAttributeStoringRep,
        [ ] );

DeclareRepresentation( "IsCapCategoryMorphismWithBialgebraActionRep",
        IsCapCategoryMorphismWithBialgebraAction and
        IsAttributeStoringRep,
        [ ] );

####################################
#
# families and types:
#
####################################

# new families:
BindGlobal( "TheFamilyOfCategoriesWithBialgebraActions",
        NewFamily( "TheFamilyOfCategoriesWithBialgebraActions" ) );

BindGlobal( "TheFamilyOfMorphismsWithBialgebraActions",
        NewFamily( "TheFamilyOfMorphismsWithBialgebraActions" ) );

# new types:
BindGlobal( "TheTypeObjectWithBialgebraAction",
        NewType( TheFamilyOfCategoriesWithBialgebraActions,
                IsCapCategoryObjectWithBialgebraActionRep ) );

BindGlobal( "TheTypeMorphismWithBialgebraAction",
        NewType( TheFamilyOfMorphismsWithBialgebraActions,
                IsCapCategoryMorphismWithBialgebraActionRep ) );

####################################
#
# global variables:
#
####################################

InstallValue( PROPAGATION_LIST_FOR_MORPHISMS_BETWEEN_OBJECTS_WITH_BIALGEBRA_ACTION,
        [
         "IsMonomorphism",
         "IsEpimorphism",
         "IsIsomorphism",
         "IsZero",
         # ..
         ]
        );

##
InstallGlobalFunction( INSTALL_TODO_LIST_FOR_MORPHISMS_BETWEEN_OBJECTS_WITH_BIALGEBRA_ACTIONS,
  function( mor, hull )
    local i;
    
    if HasIsIsomorphism( mor ) and IsIsomorphism( mor ) then
        
        SetIsIsomorphism( hull, true );
        AddToToDoList( ToDoListEntryForEqualAttributes( mor, "IsZero", hull, "IsZero" ) );
        
    else
        
        for i in PROPAGATION_LIST_FOR_MORPHISMS_BETWEEN_OBJECTS_WITH_BIALGEBRA_ACTION do
            
            AddToToDoList( ToDoListEntryForEqualAttributes( mor, i, hull, i ) );
            
        od;
        
    fi;
    
end );

####################################
#
# methods for attributes:
#
####################################

####################################
#
# methods for operations:
#
####################################

##
InstallGlobalFunction( ADD_FUNCTIONS_FOR_CATEGORY_WITH_BIALGEBRA_ACTION,
  
  function( category )
    
    ##
    AddIsWellDefinedForObjects( category,
      function( object )
        local action_endomorphisms, M;
        
        action_endomorphisms := ActionEndomorphisms( object );
        
        if not ForAll( action_endomorphisms, d -> IsEndomorphism( d ) ) then
            return false;
        fi;
        
        M := Source( action_endomorphisms[1] );
        
        return ForAll( action_endomorphisms{[ 2 .. Length( action_endomorphisms ) ]},
                       d -> IsEqualForObjects( Source( d ), M ) );
        
    end );
    
    ##
    AddIsWellDefinedForMorphisms( category,
      function( morphism )
        local action_S, action_T, mor;
        
        action_S := ActionEndomorphisms( Source( morphism ) );
        action_T := ActionEndomorphisms( Range( morphism ) );
        
        mor := UnderlyingCell( morphism );
        
        return IsWellDefinedForMorphisms( mor ) and
               ForAll( [ 1 .. Length( action_S ) ],
                       i -> PreCompose( action_S[i], mor ) = PreCompose( mor, action_T[i] ) );
        
    end );
    
    ##
    AddIsEqualForObjects( category,
      function( object_with_bialgebra_action_1, object_with_bialgebra_action_2 )
        local action_1, action_2;
        
        action_1 := ActionEndomorphisms( object_with_bialgebra_action_1 );
        action_2 := ActionEndomorphisms( object_with_bialgebra_action_2 );
        
        return IsEqualForObjects(
                       UnderlyingCell( object_with_bialgebra_action_1 ),
                       UnderlyingCell( object_with_bialgebra_action_2 ) ) and
               ForAll( [ 1 .. Length( action_1 ) ],
                       i -> IsEqualForMorphisms( action_1[i], action_2[i] ) );
        
    end );
    
    ##
    AddIsEqualForMorphisms( category,
      function( morphism_1, morphism_2 )
        
        return IsEqualForMorphisms( UnderlyingCell( morphism_1 ), UnderlyingCell( morphism_2 ) );
        
    end );
    
    ##
    AddIsCongruentForMorphisms( category,
      function( morphism_1, morphism_2 )
        
        return IsCongruentForMorphisms( UnderlyingCell( morphism_1 ), UnderlyingCell( morphism_2 ) );
        
    end );
    
end );

##
InstallMethod( CategoryWithBialgebraAction,
        "for a CAP category and a list",
        [ IsCapCategory, IsList ],
        
  function( abelian_category, bialgebra )
    local category_with_bialgebra_action, number_of_generators_of_bialgebra,
          preconditions, category_weight_list, structure_record;
    
    if not IsFinalized( abelian_category ) then
        
        Error( "the underlying category must be finalized" );
        
    elif not IsAdditiveCategory( abelian_category ) then
        
        ## TODO: support the general case
        Error( "only additive categories are supported yet" );
        
    fi;
    
    category_with_bialgebra_action := CreateCapCategory( Concatenation( Name( abelian_category ), " with bialgebra action" ) );
    
    number_of_generators_of_bialgebra := bialgebra[1];
    
    structure_record := rec(
      underlying_category := abelian_category,
      category_with_attributes := category_with_bialgebra_action,
      number_of_generators_of_bialgebra := number_of_generators_of_bialgebra
    );
    
    ## Constructors
    structure_record.ObjectPreConstructor :=
      CreateObjectConstructorForCategoryWithAttributes(
              abelian_category, category_with_bialgebra_action, TheTypeObjectWithBialgebraAction );
    
    structure_record.ObjectConstructor := function( object, attributes )
        local return_object;
        
        return_object := structure_record.ObjectPreConstructor( object, attributes );
        
        SetActionEndomorphisms( return_object, attributes );
        
        INSTALL_TODO_LIST_FOR_EQUAL_OBJECTS( object, return_object );
        
        return return_object;
        
    end;
    
    structure_record.MorphismPreConstructor :=
      CreateMorphismConstructorForCategoryWithAttributes(
              abelian_category, category_with_bialgebra_action, TheTypeMorphismWithBialgebraAction );
    
    structure_record.MorphismConstructor :=
      function( source, underlying_morphism, range )
        local morphism;
        
        morphism := structure_record.MorphismPreConstructor( source, underlying_morphism, range );
        
        INSTALL_TODO_LIST_FOR_MORPHISMS_BETWEEN_OBJECTS_WITH_BIALGEBRA_ACTIONS( underlying_morphism, morphism );
        
        return morphism;
        
    end;
    
    ##
    category_weight_list := abelian_category!.derivations_weight_list;
    
    ## ZeroObject with bialgebra action
    preconditions := [ "ZeroObject" ];
    
    if ForAll( preconditions, c -> CurrentOperationWeight( category_weight_list, c ) < infinity ) then
        
        structure_record.ZeroObject :=
          function( underlying_zero_object )
            local zero_mor;
            
            zero_mor := ZeroMorphism( underlying_zero_object, underlying_zero_object );
            
            return ListWithIdenticalEntries( number_of_generators_of_bialgebra, zero_mor );
            
          end;
    fi;
    
    ## DirectSum with bialgebra action
    preconditions := [ "DirectSum" ];
    
    if ForAll( preconditions, c -> CurrentOperationWeight( category_weight_list, c ) < infinity ) then
        
        structure_record.DirectSum :=
          function( obj_list, underlying_direct_sum )
            local n, m;
            
            n := Length( obj_list );
            
            obj_list := List( obj_list, ActionEndomorphisms );
            
            m := Length( obj_list[1] );
            
            return List( [ 1 .. m ],
                         i -> DirectSumFunctorialWithGivenDirectSums( underlying_direct_sum, List( [ 1 .. n ], j -> obj_list[j][i] ), underlying_direct_sum ) );
            
          end;
        
    fi;
    
    ## Lift along monomorphism
    preconditions := [ "IdentityMorphism",
                       "PreCompose",
                       "LiftAlongMonomorphism" ];
    
    if ForAll( preconditions, c -> CurrentOperationWeight( category_weight_list, c ) < infinity ) then
        
        structure_record.Lift :=
          function( mono, range )
            
            
            
          end;
        
    fi;
    
    ## Colift along epimorphism
    preconditions := [ "IdentityMorphism",
                       "PreCompose",
                       "ColiftAlongEpimorphism" ];
    
    if ForAll( preconditions, c -> CurrentOperationWeight( category_weight_list, c ) < infinity ) then
        
        structure_record.Colift :=
          function( epi, source )
            
            
            
          end;
        
    fi;
    
    structure_record.NoInstallList := [ "Lift", "Colift" ];
    
    structure_record.InstallList := [ "LiftAlongMonomorphism", "ColiftAlongEpimorphism" ];
    
    EnhancementWithAttributes( structure_record );
    
    ##
    InstallMethod( DMod,
                   [ IsList,
                     IsCapCategory and CategoryFilter( category_with_bialgebra_action ) ],
                   
      function( action_endomorphisms, attribute_category )
        local o;
        
        o := action_endomorphisms[1];
        
        o := VectorSpaceObject( NrRows( o ), HomalgRing( o ) );
        
        action_endomorphisms := List( action_endomorphisms, d -> VectorSpaceMorphism( o, d, o ) );
        
        return structure_record.ObjectConstructor( o, action_endomorphisms );
        
    end );
    
    ##
    InstallMethod( DMod,
                   [ IsCapCategoryObjectWithBialgebraAction and ObjectFilter( category_with_bialgebra_action ),
                     IsCapCategoryMorphism and MorphismFilter( abelian_category ),
                     IsCapCategoryObjectWithBialgebraAction and ObjectFilter( category_with_bialgebra_action ) ],
                   
      structure_record.MorphismConstructor );
    
    ## TODO: Set properties of category_with_bialgebra_action
    
    if HasIsAbelianCategory( abelian_category ) then
        SetIsAbelianCategory( category_with_bialgebra_action, IsAbelianCategory( abelian_category ) );
    fi;
    
    ADD_FUNCTIONS_FOR_CATEGORY_WITH_BIALGEBRA_ACTION( category_with_bialgebra_action );
    
    AddIsEqualForObjects( category_with_bialgebra_action, IsIdenticalObj );
    
    ## TODO: Logic for category_with_bialgebra_action
    
    Finalize( category_with_bialgebra_action );
    
    IdentityFunctor( category_with_bialgebra_action )!.UnderlyingFunctor := IdentityFunctor( abelian_category );
    
    return category_with_bialgebra_action;
    
end );

##
InstallMethod( DMod,
        [ IsCapFunctor, IsString, IsCapCategory, IsCapCategory ],
        
  function( F, name, A, B )
    local wbaF;
    
    if not IsIdenticalObj( AsCapCategory( Source( F ) ), UnderlyingCategory( A ) ) then
        Error( "the source of the functor and the category underlying the source category with bialgebra action do not coincide\n" );
    elif not IsIdenticalObj( AsCapCategory( Range( F ) ), UnderlyingCategory( B ) ) then
        Error( "the target of the functor and the category underlying the target category with bialgebra action do not coincide\n" );
    fi;
    
    wbaF := CapFunctor( name, A, B );
    
    AddObjectFunction( wbaF,
            function( obj )
              
            end );
    
    AddMorphismFunction( wbaF,
            function( new_source, mor, new_range )
              
            end );
    
    wbaF!.UnderlyingFunctor := F;
    
    return wbaF;
    
end );
    
##
InstallMethod( DMod,
        [ IsCapFunctor, IsCapCategory, IsCapCategory ],
        
  function( F, A, B )
    local name;
    
    name := "With-bialgebra-action version of ";
    name := Concatenation( name, Name( F ) );
    
    return DMod( F, name, A, B );
    
end );

##
InstallMethod( DMod,
        [ IsCapFunctor, IsString, IsCapCategory ],
        
  function( F, name, A )
    
    if not IsIdenticalObj( Source( F ), Range( F ) ) then
        Error( "the functor is not an endofunctor\n" );
    fi;
    
    return DMod( F, name, A, A );
    
end );

##
InstallMethod( DMod,
        [ IsCapFunctor, IsCapCategory ],
        
  function( F, A )
    local name;
    
    name := "With-ambient-object version of ";
    name := Concatenation( name, Name( F ) );
    
    return DMod( F, name, A );
    
end );

##
InstallMethod( DMod,
        [ IsCapNaturalTransformation, IsString, IsCapFunctor, IsCapFunctor ],
        
  function( eta, name, F, G )
    local wbaeta;
    
    if not IsIdenticalObj( Source( eta ), F!.UnderlyingFunctor ) then
        Error( "the source of the natural transformation and the functor underlying the source functor with bialgebra action do not coincide\n" );
    elif not IsIdenticalObj( Range( eta ), G!.UnderlyingFunctor ) then
        Error( "the target of the natural transformation and the functor underlying the target functor with bialgebra action do not coincide\n" );
    fi;
    
    wbaeta := NaturalTransformation( name, F, G );
    
    AddNaturalTransformationFunction(
            wbaeta,
            function( source, obj, range )
              
              return DMod( source, ApplyNaturalTransformation( eta, UnderlyingCell( obj ) ), range );
              
            end );
    
    wbaeta!.UnderlyingNaturalTransformation := eta;
    
    INSTALL_TODO_LIST_FOR_MORPHISMS_BETWEEN_OBJECTS_WITH_BIALGEBRA_ACTIONS( eta, wbaeta );
    
    return wbaeta;
    
end );

##
InstallMethod( DMod,
        [ IsCapNaturalTransformation, IsCapFunctor, IsCapFunctor ],
        
  function( eta, F, G )
    local name;
    
    name := "With-ambient-object version of ";
    name := Concatenation( name, Name( eta ) );
    
    return DMod( eta, name, F, G );
    
end );

####################################
#
# View, Print, and Display methods:
#
####################################

##
InstallMethod( ViewObj,
        "for an object with a bialgebra action",
        [ IsCapCategoryObjectWithBialgebraActionRep ],
        
  function( obj )
    
    ViewObj( UnderlyingCell( obj ) );
    Print( " with a bialgebra action" );
    
end );

##
InstallMethod( ViewObj,
        "for a morphism between objects with bialgebra actions",
        [ IsCapCategoryMorphismWithBialgebraActionRep ],
        
  function( mor )
    
    ViewObj( UnderlyingCell( mor ) );
    Print( " with a bialgebra action" );
    
end );

##
InstallMethod( Display,
        "for an object with a bialgebra action",
        [ IsCapCategoryObjectWithBialgebraActionRep ],
        
  function( obj )
    
    Display( UnderlyingCell( obj ) );
    
end );

##
InstallMethod( Display,
        "for a morphism between objects with bialgebra actions",
        [ IsCapCategoryMorphismWithBialgebraActionRep ],
        
  function( mor )
    
    Display( UnderlyingCell( mor ) );
    
end );
