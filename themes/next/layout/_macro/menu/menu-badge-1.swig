  {% macro render(value) %}
  {% set itemURL = url_for(value.split('||')[0] | trim) %}
  <li class="menu-item menu-item-{{ itemName | replace(' ', '-', 'g') }}{{ item_active(itemURL, 'menu-item-active') }}">
    <a href="{{ itemURL }}" rel="section">
      {% if theme.menu_settings.icons %}{#
      #}<i class="menu-item-icon fa fa-fw fa-{{ value.split('||')[1] | trim | default('question-circle') }}"></i> <br />{#
    #}{% endif %}{#
#}{% endmacro %}
