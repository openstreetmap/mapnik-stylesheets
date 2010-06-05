<Style name="symbols">
    <Rule>
      &maxscale_zoom9;
      &minscale_zoom10;
      <Filter>[aeroway]='airport'</Filter>
      <PointSymbolizer file="&symbols;/airport.p.16.png" type="png" width="16" height="16" />
      <TextSymbolizer name="name" fontset_name="bold-fonts" size="8" fill="#6692da" dy="-12" halo_radius="1" wrap_width="0"/>
    </Rule>
    <Rule>
      &maxscale_zoom11;
      &minscale_zoom12;
      <Filter>[aeroway]='airport'</Filter>
      <TextSymbolizer name="name" fontset_name="bold-fonts" size="9" fill="#6692da" halo_radius="1" wrap_width="0"/>
    </Rule>
    <Rule>
      &maxscale_zoom10;
      &minscale_zoom10;
      <Filter>[aeroway]='aerodrome'</Filter>
      <PointSymbolizer file="&symbols;/aerodrome.p.16.png" type="png" width="16" height="16" />
      <TextSymbolizer name="name" fontset_name="oblique-fonts" size="8" fill="#6692da" dy="-12" halo_radius="1" wrap_width="0"/>
    </Rule>
    <Rule>
      &maxscale_zoom11;
      &minscale_zoom12;
      <Filter>[aeroway]='aerodrome'</Filter>
      <TextSymbolizer name="name" fontset_name="oblique-fonts" size="8" fill="#6692da" halo_radius="1" wrap_width="0"/>
    </Rule>
    <Rule>
      &maxscale_zoom14;
      &minscale_zoom15;
      <Filter>[railway]='level_crossing'</Filter>
      <PointSymbolizer file="&symbols;/level_crossing.png" type="png" width="7" height="7" />
    </Rule>
    <Rule>
      &maxscale_zoom16;
      <Filter>[railway]='level_crossing'</Filter>
      <PointSymbolizer file="&symbols;/level_crossing2.png" type="png" width="11" height="11" />
    </Rule>
    <Rule>
      &maxscale_zoom15;
      <Filter>[man_made]='lighthouse'</Filter>
      <PointSymbolizer file="&symbols;/lighthouse.p.20.png" type="png" width="20" height="20" />
    </Rule>
    <Rule>
      &maxscale_zoom11;
      <Filter>[natural]='peak'</Filter>
      <PointSymbolizer file="&symbols;/peak.png" type="png" width="8" height="8" />
    </Rule>
    <Rule>
      &maxscale_zoom14;
      <Filter>[natural]='spring'</Filter>
      <PointSymbolizer file="&symbols;/spring.png" type="png" width="5" height="7" />
    </Rule>
    <Rule>
      &maxscale_zoom16;
      &minscale_zoom16;
      <Filter>[natural]='tree'</Filter>
      <PointSymbolizer file="&symbols;/tree.png" type="png" width="3" height="3" />
    </Rule>
    <Rule>
      &maxscale_zoom17;
      <Filter>[natural]='tree'</Filter>
      <PointSymbolizer file="&symbols;/tree2.png" type="png" width="5" height="5" />
    </Rule>
    <Rule>
      &maxscale_zoom15;
      <Filter>[man_made]='power_wind' or ([power]='generator' and [power_source] = 'wind')</Filter>
      <PointSymbolizer file="&symbols;/power_wind.png" type="png" width="16" height="26" />
    </Rule>
    <Rule>
      &maxscale_zoom16;
      <Filter>[man_made]='windmill'</Filter>
      <PointSymbolizer file="&symbols;/windmill.png" type="png" width="10" height="15" />
    </Rule>
    <Rule>
      &maxscale_zoom17;
      <Filter>[man_made]='mast'</Filter>
      <PointSymbolizer file="&symbols;/communications.p.20.png" type="png" width="20" height="20" />
    </Rule>
    <Rule>
      &maxscale_zoom15;
      <Filter>[highway]='mini_roundabout'</Filter>
      <PointSymbolizer file="&symbols;/mini_round.png" type="png" width="9" height="9" allow_overlap="false"/>
    </Rule>
    <Rule>
      &maxscale_zoom15;
      <Filter>[highway]='gate' or [barrier]='gate'</Filter>
      <PointSymbolizer file="&symbols;/gate2.png" type="png" width="7" height="5" allow_overlap="false"/>
    </Rule>
    <Rule> 
 	&maxscale_zoom16; 
 	<Filter>[barrier]='lift_gate'</Filter> 
 	<PointSymbolizer file="&symbols;/liftgate.png" type="png" width="7" height="5" allow_overlap="false"/> 
    </Rule> 
    <Rule>
      &maxscale_zoom16;
      <Filter>[barrier]='bollard'</Filter>
      <PointSymbolizer file="&symbols;/bollard.png" type="png" width="3" height="3" allow_overlap="false"/>
    </Rule>
</Style>

<Layer name="amenity-symbols" status="on" srs="&osm2pgsql_projection;">
    <StyleName>symbols</StyleName>
    <Datasource>
      <Parameter name="table">
      (select *
      from &prefix;_point
      where aeroway in ('airport','aerodrome')
         or barrier in ('bollard','gate','lift_gate')
         or highway in ('mini_roundabout','gate')
         or man_made in ('lighthouse','power_wind','windmill','mast')
         or (power='generator' and power_source='wind')
         or "natural" in ('peak','spring','tree')
         or railway='level_crossing'
      ) as symbols</Parameter>
      &datasource-settings;
    </Datasource>
</Layer>
<Layer name="amenity-symbols-poly" status="on" srs="&osm2pgsql_projection;">
    <StyleName>symbols</StyleName>
    <Datasource>
      <Parameter name="table">
      (select *
      from &prefix;_polygon
      where aeroway in ('airport','aerodrome')
         or barrier in ('bollard','gate','lift_gate')
         or highway in ('mini_roundabout','gate')
         or man_made in ('lighthouse','power_wind','windmill','mast')
         or (power='generator' and power_source='wind')
         or "natural" in ('peak','spring','tree')
         or railway='level_crossing'
      ) as symbols</Parameter>
      &datasource-settings;
    </Datasource>
</Layer>
