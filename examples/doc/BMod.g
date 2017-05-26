#! @System BMod

LoadPackage( "BMod" );

#! @Example
Q := HomalgFieldOfRationals( );
#! Q
A := MatrixCategory( Q );
#! Category of matrices over Q
B := CategoryWithBialgebraAction( A, [ 1 ] );
#! Category of matrices over Q with bialgebra action
dM := HomalgMatrix( "[ 0, 1,  0, 0 ]", 2, 2, Q );
#! <A 2 x 2 matrix over an internal ring>
M := BMod( [ dM ], B );
#! <A vector space object over Q of dimension 2> with a bialgebra action
ZeroObject( M );
#! <A vector space object over Q of dimension 0> with a bialgebra action
DirectSum( M, M );
#! <A vector space object over Q of dimension 4> with a bialgebra action
dN := HomalgMatrix( "[ 0, 1, 0,  0, 0, 1,  0, 0, 0 ]", 3, 3, Q );
#! <A 3 x 3 matrix over an internal ring>
N := BMod( [ dN ], B );
#! <A vector space object over Q of dimension 3> with a bialgebra action
phi := HomalgMatrix( "[ 0, 0, 1,  0, 0, 0 ]", 2, 3, Q );
#! <A 2 x 3 matrix over an internal ring>
phi := BMod( M, phi, N );
#! <A morphism in Category of matrices over Q>
IsWellDefined( phi );
#! true
ker := KernelObject( phi );
#! <A vector space object over Q of dimension 1>
coker := CokernelObject( phi );
#! <A vector space object over Q of dimension 2>
#! @EndExample
