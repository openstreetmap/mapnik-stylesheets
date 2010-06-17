<Style name="buildings">
    <Rule>
      <Filter>[railway] = 'station' or [building] = 'station'</Filter>
      &maxscale_zoom10;
     <PolygonSymbolizer>
         <CssParameter name="fill">#d4aaaa</CssParameter>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
      <Filter>[building] = 'supermarket'</Filter>
      &maxscale_zoom10;
      <PolygonSymbolizer>
         <CssParameter name="fill">pink</CssParameter>
         <CssParameter name="fill-opacity">0.5</CssParameter>
      </PolygonSymbolizer>
    </Rule>
    <Rule>
      <Filter>[amenity] = 'place_of_worship'</Filter>
      &maxscale_zoom10;
      &minscale_zoom14;
      <PolygonSymbolizer>
         <CssParameter name="fill">#777</CssParameter>
         <CssParameter name="fill-opacity">0.5</CssParameter>
      </PolygonSymbolizer>
    </Rule>
    <Rule>
      <Filter>[amenity] = 'place_of_worship'</Filter>
      &maxscale_zoom15;
      <PolygonSymbolizer>
         <CssParameter name="fill">#777</CssParameter>
         <CssParameter name="fill-opacity">0.5</CssParameter>
      </PolygonSymbolizer>
      <LineSymbolizer>
        <CssParameter name="stroke">#111</CssParameter>
        <CssParameter name="stroke-width">0.3</CssParameter>
      </LineSymbolizer>
    </Rule>
    <Rule>
      <Filter>[building] &lt;&gt; 'station' and [building] &lt;&gt; 'supermarket' and [building] &lt;&gt; '' and (not [amenity] &lt;&gt; '' or [amenity] &lt;&gt; 'place_of_worship')</Filter>
      &maxscale_zoom10;
      <PolygonSymbolizer>
         <CssParameter name="fill">#bca9a9</CssParameter>
      </PolygonSymbolizer>
    </Rule>
    <Rule>
      <Filter>[aeroway] = 'terminal'</Filter>
      &maxscale_zoom12;
      <PolygonSymbolizer>
         <CssParameter name="fill">#cc99ff</CssParameter>
      </PolygonSymbolizer>
    </Rule>
    <Rule>
      <Filter>[aeroway] = 'terminal'</Filter>
      &maxscale_zoom14;
      <LineSymbolizer>
        <CssParameter name="stroke">#330066</CssParameter>
        <CssParameter name="stroke-width">0.2</CssParameter>
      </LineSymbolizer>
    </Rule>
</Style>

<Layer name="buildings" status="on" srs="&osm2pgsql_projection;">
    <StyleName>buildings</StyleName>
    <Datasource>
      <Parameter name="table">
      (select way,building,leisure,railway,amenity,aeroway from &prefix;_polygon
       where (building is not null and building != 'no')
          or railway='station'
          or amenity='place_of_worship'
          or aeroway='terminal'
       order by z_order,way_area desc) as buildings
      </Parameter>
      &datasource-settings;
    </Datasource>
</Layer>

