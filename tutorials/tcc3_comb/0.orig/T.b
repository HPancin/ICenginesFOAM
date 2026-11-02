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
    object      T.b;
}
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //

dimensions      [0 0 0 1 0 0 0];

internalField
{
    type        zonal;

    defaultValue    317.68;

    zones
    {
        chamber
        {
            type            lookup;

            value           800;
        }

        intakePort
        {
            type            lookup;

            value           $defaultValue;
        }

        exhaustPort
        {
            type            lookup;

            value           520;
        }
    }
}

boundaryField
{
    #includeEtc "caseDicts/setConstraintTypes"
    staticWall
    {
        type          fixedValue;
        value         uniform 310.66;
    }

    movingWall
    {
        $staticWall;
    }

    inlet
    {
        type                inletOutlet;
        phi                 alphaPhi.b;
        inletValue          $internalField/defaultValue;
    }

    outlet
    {
        type                inletOutlet;
        phi                 alphaPhi.b;
        inletValue          uniform 520;
    }
}


// ************************************************************************* //
