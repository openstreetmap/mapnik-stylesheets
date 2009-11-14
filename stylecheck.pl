#!/usr/bin/perl

# A small (& dirty) script that creates a table giving you an estimate of which SQL queries
# will be executed at which scale denominators, by aggregating the min/max scale denominators
# for all rules and styles and matching them up with layers.

# Example result:

# Layer                    |     MinSD |     MaxSD | Table              | WHERE clause
# world                    |    750000 |        -1 |                    | 
# placenames-large         |     25000 | 200000000 | planet_osm_point   | place in ('country','state') or (place in ('city','metropolis') and capital='yes') 
# admin-01234              |    400000 | 200000000 | planet_osm_roads   | "boundary"='administrative' and admin_level in ('0','1','2','3','4') 
# roads                    |      1000 |  25000000 | planet_osm_roads   | highway is not null or railway is not null order by z_order 
# water_areas              |   3000000 |  12500000 | planet_osm_polygon | waterway in ('dock','mill_pond','riverbank','canal') or landuse in ('reservoir','water','basin') or "natural" in ('lake','water','land','marsh','scrub','wetland','glacier') order by z_order,way_area desc 
# placenames-medium        |     25000 |  12500000 | planet_osm_point   | place in ('city','metropolis','town','large_town','small_town') and (capital is null or capital&lt;&gt;'yes') 
# ferry-routes             |    400000 |   6500000 | planet_osm_line    | route='ferry'
# ...

# This can be used to improve efficiency. For example in the above table, the "roads"
# layer comes in at the early scale denominator of 25 million and selects a large
# amount of objects which may be undesirable.

# Written by Frederik Ramm <frederik@remote.org>, PD.

# Using xmlstarlet resolves all entities for us...
open(STYLE, "xmlstarlet c14n osm.xml|") or die;

my $styles = {};

while(<STYLE>)
{
    chomp;
    if (/<Style name="(.*)"/)
    {
        $styles->{$1} = { name => $1 };
        $currentstyle = $styles->{$1};
    }
    elsif (/<MaxScaleDenominator>(\d+)</)
    {
        $currentstyle->{masd} = $1 if ($currentstyle->{masd} < $1);
    }
    elsif (/<MinScaleDenominator>(\d+)</)
    {
        $currentstyle->{misd} = $1 if ($currentstyle->{misd} > $1 or !defined($currentstyle->{misd}));
    }
    elsif (/<Layer\s.*name="([^"]+)"/)
    {
        $currentlayername = $1;
        undef $misd;
        undef $masd;
        undef $sel;
        undef $from;
        undef $where;
    }
    elsif (/<StyleName>(.*)</)
    {
        my $style = $styles->{$1};
        if (!defined($style))
        {
            die "layer '$currentlayername' references undefined style '$1'";
        }
        $misd = $style->{misd} if ($misd > $style->{misd} or !defined($misd));
        $masd = $style->{masd} if ($masd < $style->{masd});
    }
    elsif (/<Parameter name="table">(.*)/)
    {
        my $table = $1;
        while($table !~ /<\/Parameter>/)
        {
            $_ = <STYLE>;
            chomp;
            $table .= $_;
        }
        if ($table !~ /^\s*\((.*)\)\s+as\s+\S+\s*<\/Parameter>$/i)
        {
            die "parse error: $table";
        }
        $table = $1;
        $table =~ s/\s+/ /g;
        $table =~ /select (.*) from (.*)( where (.*))/ or die;
        ($sel, $from, $where) = ($1, $2, $4);
    }
    elsif (/<\/Layer>/)
    {
        push (@results, { masd => $masd, detail =>
            sprintf "%-24s | %9d | %9d | %-18s | %s\n",
            $currentlayername, $misd, $masd, $from, $where });
    }
}

printf "%-24s | %9s | %9s | %-18s | %s\n",
    "Layer", "MinSD", "MaxSD", "Table", "WHERE clause";

foreach my $layer (sort { $b->{masd} <=> $a->{masd} } @results)
{
    print $layer->{detail};
}

