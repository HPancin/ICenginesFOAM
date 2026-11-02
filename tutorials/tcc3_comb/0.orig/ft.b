/*--------------------------------*- C++ -*----------------------------------*\
  =========                 |
  \\      /  F ield         | OpenFOAM: The Open Source CFD Toolbox
   \\    /   O peration     | Website:  https://openfoam.org
    \\  /    A nd           | Version:  dev
     \\/     M anipulation  |
\*---------------------------------------------------------------------------*/
FoamFile
{
    format      ascii;
    class       volScalarField;
    location    "0";
    object      ft.b;
}
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //

dimensions      [0 0 0 0 0 0 0];

// Fuel mass fraction in the burnt phase (0 for stoichiometric charge)
internalField   uniform 0;

boundaryField
{
    #includeEtc "caseDicts/setConstraintTypes"

    staticWall
    {
        type            zeroGradient;
    }

    movingWall
    {
        $staticWall;
    }

    inlet
    {
        type            inletOutlet;
        phi             alphaPhi.b;
        inletValue      uniform 0;
        value           uniform 0;
    }

    outlet
    {
        type            inletOutlet;
        phi             alphaPhi.b;
        inletValue      uniform 0;
        value           uniform 0;
    }
}


// ************************************************************************* //
