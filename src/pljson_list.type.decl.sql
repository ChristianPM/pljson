create or replace type pljson_list force under pljson_element (
  
  /*
  Copyright (c) 2010 Jonas Krogsboell
  
  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:
  
  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.
  
  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  THE SOFTWARE.
  */
  
  /**
   * <p>This package defines <em>PL/JSON</em>'s representation of the JSON
   * array type, e.g. <code>[1, 2, "foo", "bar"]</code>.</p>
   *
   * <p>The primary method exported by this package is the <code>pljson_list</code>
   * method.</p>
   *
   * <strong>Example:</strong>
   *
   * <pre>
   * declare
   *   myarr pljson_list := pljson_list('[1, 2, "foo", "bar"]');
   * begin
   *   myarr.get(1).print(); // => dbms_output.put_line(1)
   *   myarr.get(3).print(); // => dbms_output.put_line('foo')
   * end;
   * </pre>
   *
   * @headcom
   */
  
  /** Private variable for internal processing. */
  list_data pljson_value_array,
  
  /**
   * <p>Create an empty list.</p>
   *
   * <pre>
   * declare
   *   myarr pljson_list := pljson_list();
   * begin
   *   dbms_output.put_line(myarr.count()); // => 0
   * end;
   *
   * @return An instance of <code>pljson_list</code>.
   */
  constructor function pljson_list return self as result,
  
  /**
   * <p>Create an instance from a given JSON array representation.</p>
   *
   * <pre>
   * declare
   *   myarr pljson_list := pljson_list('[1, 2, "foo", "bar"]');
   * begin
   *   myarr.get(1).print(); // => dbms_output.put_line(1)
   *   myarr.get(3).print(); // => dbms_output.put_line('foo')
   * end;
   * </pre>
   *
   * @param str The JSON array string to parse.
   * @return An instance of <code>pljson_list</code>.
   */
  constructor function pljson_list(str varchar2) return self as result,
  
  /**
   * <p>Create an instance from a given JSON array representation stored in
   * a <code>CLOB</code>.</p>
   *
   * @param str The <code>CLOB</code> to parse.
   * @return An instance of <code>pljson_list</code>.
   */
  constructor function pljson_list(str clob) return self as result,
  
  /**
   * <p>Create an instance from a given instance of <code>pljson_value</code>
   * that represents an array.</p>
   *
   * @param elem The <code>pljson_value</code> to cast to a <code>pljson_list</code>.
   * @return An instance of <code>pljson_list</code>.
   */
  constructor function pljson_list(elem pljson_value) return self as result,
  
  member procedure append(self in out nocopy pljson_list, elem pljson_value, position pls_integer default null),
  member procedure append(self in out nocopy pljson_list, elem varchar2, position pls_integer default null),
  member procedure append(self in out nocopy pljson_list, elem number, position pls_integer default null),
  /* E.I.Sarmas (github.com/dsnz)   2016-12-01   support for binary_double numbers */
  member procedure append(self in out nocopy pljson_list, elem binary_double, position pls_integer default null),
  member procedure append(self in out nocopy pljson_list, elem boolean, position pls_integer default null),
  member procedure append(self in out nocopy pljson_list, elem pljson_list, position pls_integer default null),
  
  member procedure replace(self in out nocopy pljson_list, position pls_integer, elem pljson_value),
  member procedure replace(self in out nocopy pljson_list, position pls_integer, elem varchar2),
  member procedure replace(self in out nocopy pljson_list, position pls_integer, elem number),
  /* E.I.Sarmas (github.com/dsnz)   2016-12-01   support for binary_double numbers */
  member procedure replace(self in out nocopy pljson_list, position pls_integer, elem binary_double),
  member procedure replace(self in out nocopy pljson_list, position pls_integer, elem boolean),
  member procedure replace(self in out nocopy pljson_list, position pls_integer, elem pljson_list),
  
  member function count return number,
  member procedure remove(self in out nocopy pljson_list, position pls_integer),
  member procedure remove_first(self in out nocopy pljson_list),
  member procedure remove_last(self in out nocopy pljson_list),
  member function get(position pls_integer) return pljson_value,
  member function head return pljson_value,
  member function last return pljson_value,
  member function tail return pljson_list,
  
  /* Output methods */
  member function to_char(spaces boolean default true, chars_per_line number default 0) return varchar2,
  member procedure to_clob(self in pljson_list, buf in out nocopy clob, spaces boolean default false, chars_per_line number default 0, erase_clob boolean default true),
  member procedure print(self in pljson_list, spaces boolean default true, chars_per_line number default 8192, jsonp varchar2 default null), --32512 is maximum
  member procedure htp(self in pljson_list, spaces boolean default false, chars_per_line number default 0, jsonp varchar2 default null),
  
  /* json path */
  member function path(json_path varchar2, base number default 1) return pljson_value,
  /* json path_put */
  member procedure path_put(self in out nocopy pljson_list, json_path varchar2, elem pljson_value, base number default 1),
  member procedure path_put(self in out nocopy pljson_list, json_path varchar2, elem varchar2, base number default 1),
  member procedure path_put(self in out nocopy pljson_list, json_path varchar2, elem number, base number default 1),
  /* E.I.Sarmas (github.com/dsnz)   2016-12-01   support for binary_double numbers */
  member procedure path_put(self in out nocopy pljson_list, json_path varchar2, elem binary_double, base number default 1),
  member procedure path_put(self in out nocopy pljson_list, json_path varchar2, elem boolean, base number default 1),
  member procedure path_put(self in out nocopy pljson_list, json_path varchar2, elem pljson_list, base number default 1),
  
  /* json path_remove */
  member procedure path_remove(self in out nocopy pljson_list, json_path varchar2, base number default 1),
  
  member function to_json_value return pljson_value
  /* --backwards compatibility
  member procedure add_elem(self in out nocopy json_list, elem json_value, position pls_integer default null),
  member procedure add_elem(self in out nocopy json_list, elem varchar2, position pls_integer default null),
  member procedure add_elem(self in out nocopy json_list, elem number, position pls_integer default null),
  member procedure add_elem(self in out nocopy json_list, elem boolean, position pls_integer default null),
  member procedure add_elem(self in out nocopy json_list, elem json_list, position pls_integer default null),

  member procedure set_elem(self in out nocopy json_list, position pls_integer, elem json_value),
  member procedure set_elem(self in out nocopy json_list, position pls_integer, elem varchar2),
  member procedure set_elem(self in out nocopy json_list, position pls_integer, elem number),
  member procedure set_elem(self in out nocopy json_list, position pls_integer, elem boolean),
  member procedure set_elem(self in out nocopy json_list, position pls_integer, elem json_list),

  member procedure remove_elem(self in out nocopy json_list, position pls_integer),
  member function get_elem(position pls_integer) return json_value,
  member function get_first return json_value,
  member function get_last return json_value
--*/

) not final;
/
sho err
