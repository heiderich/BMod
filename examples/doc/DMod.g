#! @System DMod

LoadPackage( "DMod" );

#! @Example
Q := HomalgFieldOfRationals( );
#! Q
A := MatrixCategory( Q );
#! Category of matrices over Q
B := CategoryWithBialgebraAction( A, [ 1 ] );
#! Category of matrices over Q with bialgebra action
d := HomalgMatrix( "[ 0, 1, 0, 0 ]", 2, 2, Q );
#! <A matrix over an internal ring>
M := DMod( [ d ], B );
#! <A vector space object over Q of dimension 2> with a bialgebra action
ZeroObject( M );
#! <A vector space object over Q of dimension 0> with a bialgebra action
DirectSum( M, M );
#! <A vector space object over Q of dimension 4> with a bialgebra action
#! @EndExample
