<Style name="water_areas">
    <Rule>
      <Filter>[natural] = 'glacier'</Filter>
      &maxscale_zoom6;
      &minscale_zoom7;
      <LineSymbolizer>
        <CssParameter name="stroke">#9cf</CssParameter>
        <CssParameter name="stroke-width">1.5</CssParameter>
        <CssParameter name="stroke-dasharray">4,2</CssParameter>
      </LineSymbolizer>
      <PolygonPatternSymbolizer file="&symbols;/glacier.png" type="png" width="40" height="32"/>
    </Rule>
    <Rule>
      <Filter>[natural] = 'glacier'</Filter>
      &maxscale_zoom8;
      <LineSymbolizer>
        <CssParameter name="stroke">#9cf</CssParameter>
        <CssParameter name="stroke-width">1.5</CssParameter>
        <CssParameter name="stroke-dasharray">4,2</CssParameter>
      </LineSymbolizer>
      <PolygonPatternSymbolizer file="&symbols;/glacier2.png" type="png" width="70" height="56"/>
    </Rule>
    <Rule>
      <Filter>[waterway] = 'dock' or [waterway] = 'mill_pond' or [waterway]='canal'</Filter>
      &maxscale_zoom9;
      <PolygonSymbolizer>
        <CssParameter name="fill">#b5d0d0</CssParameter>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
      <Filter>[landuse] = 'basin'</Filter>
      &maxscale_zoom7;
      <PolygonSymbolizer>
        <CssParameter name="fill">#b5d0d0</CssParameter>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
      <Filter>[natural] = 'lake' or [natural] = 'water' or [landuse] = 'reservoir' or [waterway] = 'riverbank' or [landuse] = 'water'</Filter>
      &maxscale_zoom6;
      <PolygonSymbolizer>
        <CssParameter name="fill">#b5d0d0</CssParameter>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
      &maxscale_zoom13;
      <Filter>[natural] = 'marsh' or [natural] = 'wetland'</Filter>
      <PolygonPatternSymbolizer file="&symbols;/marsh.png" type="png" width="30" height="30"/>
    </Rule>
    <Rule>
      &maxscale_zoom13;
      <Filter>[natural] = 'scrub'</Filter>
      <PolygonPatternSymbolizer file="&symbols;/scrub.png" type="png" width="30" height="30"/>
    </Rule>
    <Rule>
      <Filter>[natural] = 'land'</Filter>
      &maxscale_zoom10;
      <PolygonSymbolizer>
        <CssParameter name="fill">#f2efe9</CssParameter>
     </PolygonSymbolizer>
    </Rule>
</Style>
<Style name="glaciers-text">
    <Rule> 
      <Filter>[way_area] &gt;= 10000000</Filter>
      &maxscale_zoom10;
      <TextSymbolizer name="name" fontset_name="book-fonts" size="9" fill="#99f" halo_radius="1" wrap_width="20"/>
    </Rule>
    <Rule>
      <Filter>[way_area] &gt;= 5000000 and [way_area] &lt; 10000000</Filter>
      &maxscale_zoom11;
      <TextSymbolizer name="name" fontset_name="book-fonts" size="9" fill="#99f" halo_radius="1" wrap_width="20"/>
    </Rule>
    <Rule>
      <Filter>[way_area] &lt; 5000000</Filter>
      &maxscale_zoom12;
      <TextSymbolizer name="name" fontset_name="book-fonts" size="9" fill="#99f" halo_radius="1" wrap_width="20"/>
    </Rule>
</Style>
<Style name="water_lines">
    <Rule>
      <Filter>[waterway]='weir'</Filter>
      &maxscale_zoom15;
      &minscale_zoom18;
      <LineSymbolizer>
        <CssParameter name="stroke">#aaa</CssParameter>
        <CssParameter name="stroke-width">2</CssParameter>
        <CssParameter name="stroke-linejoin">round</CssParameter>
        <CssParameter name="stroke-linecap">round</CssParameter>
      </LineSymbolizer>
    </Rule>
    <Rule>
      <Filter>[waterway]='river'</Filter>
      &maxscale_zoom12;
      &minscale_zoom12;
      <LineSymbolizer>
        <CssParameter name="stroke">#b5d0d0</CssParameter>
        <CssParameter name="stroke-width">2</CssParameter>
        <CssParameter name="stroke-linejoin">round</CssParameter>
        <CssParameter name="stroke-linecap">round</CssParameter>
      </LineSymbolizer>
    </Rule>
    <Rule>
      <Filter>[waterway]='river'</Filter>
      &maxscale_zoom13;
      &minscale_zoom13;
      <LineSymbolizer>
        <CssParameter name="stroke">#b5d0d0</CssParameter>
        <CssParameter name="stroke-width">3</CssParameter>
        <CssParameter name="stroke-linejoin">round</CssParameter>
        <CssParameter name="stroke-linecap">round</CssParameter>
      </LineSymbolizer>
    </Rule>
    <Rule>
      <Filter>[waterway]='river'</Filter>
      &maxscale_zoom14;
      &minscale_zoom14;
      <LineSymbolizer>
        <CssParameter name="stroke">#b5d0d0</CssParameter>
        <CssParameter name="stroke-width">5</CssParameter>
        <CssParameter name="stroke-linejoin">round</CssParameter>
        <CssParameter name="stroke-linecap">round</CssParameter>
      </LineSymbolizer>
    </Rule><Rule>
      <Filter>[waterway]='river'</Filter>
      &maxscale_zoom15;
      &minscale_zoom16;
      <LineSymbolizer>
        <CssParameter name="stroke">#b5d0d0</CssParameter>
        <CssParameter name="stroke-width">6</CssParameter>
        <CssParameter name="stroke-linejoin">round</CssParameter>
        <CssParameter name="stroke-linecap">round</CssParameter>
      </LineSymbolizer>
    </Rule>
    <Rule>
      <Filter>[waterway]='river'</Filter>
      &maxscale_zoom17;
      &minscale_zoom17;
      <LineSymbolizer>
        <CssParameter name="stroke">#b5d0d0</CssParameter>
        <CssParameter name="stroke-width">10</CssParameter>
        <CssParameter name="stroke-linejoin">round</CssParameter>
        <CssParameter name="stroke-linecap">round</CssParameter>
      </LineSymbolizer>
    </Rule>
    <Rule>
      <Filter>[waterway]='river'</Filter>
      &maxscale_zoom18;
      &minscale_zoom18;
      <LineSymbolizer>
        <CssParameter name="stroke">#b5d0d0</CssParameter>
        <CssParameter name="stroke-width">12</CssParameter>
        <CssParameter name="stroke-linejoin">round</CssParameter>
        <CssParameter name="stroke-linecap">round</CssParameter>
      </LineSymbolizer>
    </Rule>
    <Rule>
      <Filter>[waterway]='canal' and not [disused]='yes'</Filter>
      &maxscale_zoom12;
      &minscale_zoom12;
      <LineSymbolizer>
        <CssParameter name="stroke">#b5d0d0</CssParameter>
        <CssParameter name="stroke-width">3</CssParameter>
        <CssParameter name="stroke-linejoin">round</CssParameter>
        <CssParameter name="stroke-linecap">round</CssParameter>
      </LineSymbolizer>
    </Rule>
    <Rule>
      <Filter>[waterway]='canal' and not [disused]='yes'</Filter>
      &maxscale_zoom13;
      &minscale_zoom13;
      <LineSymbolizer>
        <CssParameter name="stroke">#b5d0d0</CssParameter>
        <CssParameter name="stroke-width">4</CssParameter>
        <CssParameter name="stroke-linejoin">round</CssParameter>
        <CssParameter name="stroke-linecap">round</CssParameter>
      </LineSymbolizer>
      <TextSymbolizer name="name" fontset_name="book-fonts" size="8" fill="#6699cc" halo_radius="1" placement="line"/>
    </Rule>
    <Rule>
      <ElseFilter/> <!--[waterway]='stream'</Filter>-->
      &maxscale_zoom13;
      &minscale_zoom14;
      <LineSymbolizer>
        <CssParameter name="stroke">#b5d0d0</CssParameter>
        <CssParameter name="stroke-width">1</CssParameter>
      </LineSymbolizer>
    </Rule>
    <Rule>
      <Filter>[waterway]='river' and [tunnel] = 'yes'</Filter>
      &maxscale_zoom14;
      &minscale_zoom14;
      <LineSymbolizer>
        <CssParameter name="stroke">#b5d0d0</CssParameter>
        <CssParameter name="stroke-width">6</CssParameter>
        <CssParameter name="stroke-dasharray">4,2</CssParameter>
      </LineSymbolizer>
      <LineSymbolizer>
        <CssParameter name="stroke">white</CssParameter>
        <CssParameter name="stroke-width">4</CssParameter>
      </LineSymbolizer>
      <TextSymbolizer name="name" fontset_name="book-fonts" size="10" fill="#6699cc" halo_radius="1" placement="line" min_distance="200"/>
    </Rule><Rule>
      <Filter>[waterway]='river' and [tunnel] = 'yes'</Filter>
      &maxscale_zoom15;
      &minscale_zoom16;
      <LineSymbolizer>
        <CssParameter name="stroke">#b5d0d0</CssParameter>
        <CssParameter name="stroke-width">7</CssParameter>
        <CssParameter name="stroke-dasharray">4,2</CssParameter>
      </LineSymbolizer>
      <LineSymbolizer>
        <CssParameter name="stroke">white</CssParameter>
        <CssParameter name="stroke-width">4</CssParameter>
      </LineSymbolizer>
      <TextSymbolizer name="name" fontset_name="book-fonts" size="10" fill="#6699cc" halo_radius="1" placement="line" min_distance="200"/>
    </Rule>
    <Rule>
      <Filter>[waterway]='river' and [tunnel] = 'yes'</Filter>
      &maxscale_zoom17;
      &minscale_zoom17;
      <LineSymbolizer>
        <CssParameter name="stroke">#b5d0d0</CssParameter>
        <CssParameter name="stroke-width">11</CssParameter>
        <CssParameter name="stroke-dasharray">4,2</CssParameter>
      </LineSymbolizer>
      <LineSymbolizer>
        <CssParameter name="stroke">white</CssParameter>
        <CssParameter name="stroke-width">7</CssParameter>
      </LineSymbolizer>
      <TextSymbolizer name="name" fontset_name="book-fonts" size="10" fill="#6699cc" halo_radius="1" placement="line" min_distance="200"/>
    </Rule>
    <Rule>
      <Filter>[waterway]='river' and [tunnel] = 'yes'</Filter>
      &maxscale_zoom18;
      <LineSymbolizer>
        <CssParameter name="stroke">#b5d0d0</CssParameter>
        <CssParameter name="stroke-width">13</CssParameter>
        <CssParameter name="stroke-dasharray">4,2</CssParameter>
      </LineSymbolizer>
      <LineSymbolizer>
        <CssParameter name="stroke">white</CssParameter>
        <CssParameter name="stroke-width">9</CssParameter>
      </LineSymbolizer>
      <TextSymbolizer name="name" fontset_name="book-fonts" size="10" fill="#6699cc" halo_radius="1" placement="line" min_distance="200"/>
    </Rule>
    <Rule>
      <Filter>[waterway]='canal' and [tunnel] = 'yes'</Filter>
      &maxscale_zoom14;
      &minscale_zoom16;
       <LineSymbolizer>
        <CssParameter name="stroke">#b5d0d0</CssParameter>
        <CssParameter name="stroke-width">7</CssParameter>
        <CssParameter name="stroke-dasharray">4,2</CssParameter>
      </LineSymbolizer>
      <LineSymbolizer>
        <CssParameter name="stroke">white</CssParameter>
        <CssParameter name="stroke-width">3</CssParameter>
      </LineSymbolizer>
      <TextSymbolizer name="name" fontset_name="book-fonts" size="9" fill="#6699cc" halo_radius="1" placement="line"/>
    </Rule>
    <Rule>
      <Filter>[waterway]='canal' and not ([tunnel] = 'yes' or [disused]='yes')</Filter>
      &maxscale_zoom14;
      &minscale_zoom16;
      <LineSymbolizer>
        <CssParameter name="stroke">#b5d0d0</CssParameter>
        <CssParameter name="stroke-width">7</CssParameter>
        <CssParameter name="stroke-linejoin">round</CssParameter>
        <CssParameter name="stroke-linecap">round</CssParameter>
      </LineSymbolizer>
      <TextSymbolizer name="name" fontset_name="book-fonts" size="9" fill="#6699cc" halo_radius="1" placement="line"/>
    </Rule>
    <Rule>
      <Filter>[waterway]='canal' and [tunnel] = 'yes'</Filter>
      &maxscale_zoom17;
      &minscale_zoom18;
       <LineSymbolizer>
        <CssParameter name="stroke">#b5d0d0</CssParameter>
        <CssParameter name="stroke-width">11</CssParameter>
        <CssParameter name="stroke-dasharray">4,2</CssParameter>
      </LineSymbolizer>
      <LineSymbolizer>
        <CssParameter name="stroke">white</CssParameter>
        <CssParameter name="stroke-width">7</CssParameter>
      </LineSymbolizer>
      <TextSymbolizer name="name" fontset_name="book-fonts" size="9" fill="#6699cc" halo_radius="1" placement="line"/>
    </Rule>
    <Rule>
      <Filter>[waterway]='canal' and not ([tunnel] = 'yes' or [disused]='yes' or [lock]='yes')</Filter>
      &maxscale_zoom17;
      &minscale_zoom18;
      <LineSymbolizer>
        <CssParameter name="stroke">#b5d0d0</CssParameter>
        <CssParameter name="stroke-width">11</CssParameter>
        <CssParameter name="stroke-linejoin">round</CssParameter>
        <CssParameter name="stroke-linecap">round</CssParameter>
      </LineSymbolizer>
      <TextSymbolizer name="name" fontset_name="book-fonts" size="9" fill="#6699cc" halo_radius="1" placement="line"/>
    </Rule>
    <Rule>
      <Filter>[waterway]='canal' and not ([tunnel] = 'yes' or [disused]='yes') and [lock]='yes'</Filter>
      &maxscale_zoom17;
      &minscale_zoom18;
      <LineSymbolizer>
        <CssParameter name="stroke">#b5d0d0</CssParameter>
        <CssParameter name="stroke-width">7</CssParameter>
        <CssParameter name="stroke-linejoin">round</CssParameter>
        <CssParameter name="stroke-linecap">round</CssParameter>
      </LineSymbolizer>
      <TextSymbolizer name="name" fontset_name="book-fonts" size="9" fill="#6699cc" halo_radius="1" dy="-5" wrap_width="20"/>
    </Rule>
    <Rule>
      <Filter>[waterway]='derelict_canal' or ([waterway]='canal' and [disused]='yes')</Filter>
      &maxscale_zoom12;
      &minscale_zoom12;
      <LineSymbolizer>
        <CssParameter name="stroke">#b5e4d0</CssParameter>
        <CssParameter name="stroke-width">1.5</CssParameter>
        <CssParameter name="stroke-dasharray">4,4</CssParameter>
        <CssParameter name="stroke-opacity">0.5</CssParameter>
        <CssParameter name="stroke-linejoin">round</CssParameter>
        <CssParameter name="stroke-linecap">round</CssParameter>
      </LineSymbolizer>
    </Rule>
    <Rule>
      <Filter>[waterway]='derelict_canal' or ([waterway]='canal' and [disused]='yes')</Filter>
      &maxscale_zoom13;
      &minscale_zoom13;
      <LineSymbolizer>
        <CssParameter name="stroke">#b5e4d0</CssParameter>
        <CssParameter name="stroke-width">2.5</CssParameter>
        <CssParameter name="stroke-dasharray">4,6</CssParameter>
        <CssParameter name="stroke-opacity">0.5</CssParameter>
        <CssParameter name="stroke-linejoin">round</CssParameter>
        <CssParameter name="stroke-linecap">round</CssParameter>
      </LineSymbolizer>
      <TextSymbolizer name="name" fontset_name="book-fonts" size="9" fill="#80d1ae" halo_radius="1" spacing="600" placement="line"/>
    </Rule>
    <Rule>
      <Filter>[waterway]='derelict_canal' or ([waterway]='canal' and [disused]='yes')</Filter>
      &maxscale_zoom14;
      &minscale_zoom18;
      <LineSymbolizer>
        <CssParameter name="stroke">#b5e4d0</CssParameter>
        <CssParameter name="stroke-width">4.5</CssParameter>
        <CssParameter name="stroke-dasharray">4,8</CssParameter>
        <CssParameter name="stroke-opacity">0.5</CssParameter>
        <CssParameter name="stroke-linejoin">round</CssParameter>
        <CssParameter name="stroke-linecap">round</CssParameter>
      </LineSymbolizer>
      <TextSymbolizer name="name" fontset_name="book-fonts" size="10" fill="#80d1ae" halo_radius="1" spacing="600" placement="line"/>
    </Rule>
    <Rule>
      <Filter>[waterway]='stream' and [tunnel]='yes'</Filter>
      &maxscale_zoom15;
      &minscale_zoom18;
      <LineSymbolizer>
        <CssParameter name="stroke">#b5d0d0</CssParameter>
        <CssParameter name="stroke-width">2.4</CssParameter>
        <CssParameter name="stroke-dasharray">4,2</CssParameter>
      </LineSymbolizer>
      <LineSymbolizer>
        <CssParameter name="stroke">#f3f7f7</CssParameter>
        <CssParameter name="stroke-width">1.2</CssParameter>
      </LineSymbolizer>
    </Rule>
    <Rule>
      <Filter>[waterway]='stream' and not [tunnel]='yes'</Filter>
      &maxscale_zoom15;
      &minscale_zoom18;
      <LineSymbolizer>
        <CssParameter name="stroke">#b5d0d0</CssParameter>
        <CssParameter name="stroke-width">2</CssParameter>
      </LineSymbolizer>
      <TextSymbolizer name="name" fontset_name="book-fonts" size="8" fill="#6699cc" halo_radius="1" spacing="600" placement="line"/>
    </Rule>
    <Rule>
      <Filter>([waterway]='drain' or [waterway]='ditch') and [tunnel]='yes'</Filter>
      &maxscale_zoom15;
      &minscale_zoom18;
      <LineSymbolizer>
        <CssParameter name="stroke">#b5d0d0</CssParameter>
        <CssParameter name="stroke-width">2</CssParameter>
        <CssParameter name="stroke-dasharray">4,2</CssParameter>
      </LineSymbolizer>
      <LineSymbolizer>
        <CssParameter name="stroke">#f3f7f7</CssParameter>
        <CssParameter name="stroke-width">1</CssParameter>
      </LineSymbolizer>
    </Rule>
    <Rule>
      <Filter>([waterway]='drain' or [waterway]='ditch') and not [tunnel]='yes'</Filter>
      &maxscale_zoom15;
      &minscale_zoom18;
      <LineSymbolizer>
        <CssParameter name="stroke">#b5d0d0</CssParameter>
        <CssParameter name="stroke-width">1</CssParameter>
      </LineSymbolizer>
      <TextSymbolizer name="name" fontset_name="book-fonts" size="8" fill="#6699cc" halo_radius="1" spacing="600" placement="line"/>
    </Rule>

    <Rule>
      <ElseFilter/> <!--[waterway]='stream'</Filter>-->
      &maxscale_zoom15;
      &minscale_zoom18;
      <LineSymbolizer>
        <CssParameter name="stroke">#b5d0d0</CssParameter>
        <CssParameter name="stroke-width">2</CssParameter>
      </LineSymbolizer>
    </Rule>
</Style>

<Layer name="water_areas" status="on" srs="&osm2pgsql_projection;">
    <StyleName>water_areas</StyleName>
    <Datasource>
      <Parameter name="table">
      (select way,"natural",waterway,landuse,name
      from &prefix;_polygon
      where waterway in ('dock','mill_pond','riverbank','canal')
         or landuse in ('reservoir','water','basin')
         or "natural" in ('lake','water','land','marsh','scrub','wetland','glacier')
      order by z_order,way_area desc
      ) as water_areas</Parameter>
      &datasource-settings;
    </Datasource>
</Layer>
<Layer name="glaciers-text" status="on" srs="&osm2pgsql_projection;">
    <StyleName>glaciers-text</StyleName>
    <Datasource>
      <Parameter name="table">
      (select way,name,way_area
      from &prefix;_polygon
      where "natural"='glacier'
      order by way_area desc
      ) as glaciers</Parameter>
      &datasource-settings;
    </Datasource>
</Layer>
<Layer name="water_lines" status="on" srs="&osm2pgsql_projection;">
    <StyleName>water_lines</StyleName>
    <Datasource>
      <Parameter name="table">
      (select way,waterway,disused,lock,name,
      case when tunnel in ('yes','true','1') then 'yes'::text else tunnel end as tunnel
      from &prefix;_line
      where waterway in ('weir','river','canal','derelict_canal','stream','drain')
        and (bridge is null or bridge not in ('yes','true','1','aqueduct'))
      order by z_order
      ) as water_lines</Parameter>
      &datasource-settings;
    </Datasource>
</Layer>
