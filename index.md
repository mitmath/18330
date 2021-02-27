Notebooks:

<ul>
    {% for page in site.static_files %}
        {% if page.extname == ".html" %}
            <li><a href="{{ page.path | absolute_url }}">{{ page.name }}</a></li>
        {% endif %}
    {% endfor %}
</ul>

<br>
<br>
<br>
