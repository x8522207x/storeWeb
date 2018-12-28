<%@ page language="java" pageEncoding="utf-8" %>
<%--
/*
	DEBUG = true;
	out2 = out;

*	<%@ include file="../inc/function_uni.jsp"
*	
	2011/11/11	toHtmlString null return "&nbsp;";
	2012/05/07	toXmlString "&nbsp;" 去掉
*/
--%>
<%@page import="java.io.*" %>
<%@page import="java.net.*" %>
<%@page import="java.text.*"%>
<%@page import="java.util.*"%>
<%@page import="javax.net.ssl.HttpsURLConnection" %>

<%!
	String REFERRER_OK = "http://dhtext.yousheng.ipicbox.tw/";
	boolean DEBUG = true;
	boolean checkReferrer(String from){
		if(getString(from).startsWith(REFERRER_OK)){
			return true;
		}else{
			return false;
		}
	}
	String getExpires(int days){
		String result = "";
		try{
			Calendar calendar = Calendar.getInstance();
			calendar.add(Calendar.DATE, days);
			SimpleDateFormat sdf = new SimpleDateFormat("EEE, d MMM yyyy HH:mm:ss");
			result = sdf.format(calendar.getTime());
			System.out.println(result);
			//<meta http-equiv="expires" content="mon, 27 sep 2010 14:30:00 GMT">
		}catch(Exception e){
			e.printStackTrace();
		}
		return result;
	}

	String toXmlString(String s1){
		if(s1==null)return "";
		String s2=s1;
		s2 = s2.replaceAll( "&nbsp;"," " ); 
		s2 = s2.replaceAll( "&","&#38;" ); 
		s2 = s2.replaceAll( "&#38;#","&#" ); 

		s2 = s2.replaceAll( "'","&#39;" );
		s2 = s2.replaceAll( "\"","&#34;" );
		s2 = s2.replaceAll( "<","&#60;" );
		s2 = s2.replaceAll( ">","&#62;" ); 
		return s2;
	}

	String cleanSpecialChar(String s1){
		if(s1==null)return "";
		String s2 = s1.replaceAll( "'","" );
		s2 = s2.replaceAll( "\"","" );
		s2 = s2.replaceAll( "<","" );
		s2 = s2.replaceAll( ">","" ); 
		return s2;
	}

	String toHtmlString(String s1){
		if(s1==null)return "&nbsp;";
		String s2 = s1.replaceAll( "'","&#39;" );
		s2 = s2.replaceAll( "\"","&#34;" );
		s2 = s2.replaceAll( "<","&#60;" );
		s2 = s2.replaceAll( ">","&#62;" ); 
		return s2;
	}
	String toHtmlString(String s1, int limit){
		if(s1==null)return "&nbsp;";
		if(s1.length()>limit)return toHtmlString(s1.substring(0,limit-1))+"...";
		return toHtmlString(s1);
	}
	String toHtmlActionString(String s1){
		if(s1==null)return "";
//		String s2 = s1.replaceAll( "'","\\\\&#39;" );//	\\&#39;
//		s2 = s2.replaceAll( "\"","\\\\&#34;" );//		\\&#34;
		String s2 = s1.replaceAll( "'","&#39;" );//	\\&#39;
		s2 = s2.replaceAll( "\"","&#34;" );//		\\&#34;
		s2 = s2.replaceAll( "<","&#60;" );
		s2 = s2.replaceAll( ">","&#62;" );
		return s2;
	}
	String toJavaScriptString(String s1){
		if(s1==null)return "";
		String s2 = s1.replaceAll( "'","\\\\\'" );//	\\'
		s2 = s2.replaceAll( "\"","\\\\\"" );//			\\"
		return s2;
	}
    public static String toSqlString(String s1) {
        String s2 = s1.replaceAll("'", "\'\'");//		''
        //s2 = s2.replaceAll("\\\\", "\\\\\\\\");
        return s2;
    }
    /**
     * sql 中還要加 escape '/' 如下例
     * sql = "select * from test t where test like '"+toSqlSearchString(s1)+"' escape '/'";
	 * 每個 like '' 都要加  escape '/'  不是 like 請用 toSqlString
     * @param s1 String
     * @return String
     */
    public static String toSqlSearchString(String s1) {
		if(s1==null)return "";
        String s2 = s1.replaceAll("'", "\'\'");
        s2 = s2.replaceAll("/", "//");
        s2 = s2.replaceAll("_", "/_");
        s2 = s2.replaceAll("%", "/%");
        return s2;
	}
	/**
	 * 消除字串中的 HTML TAG，html 標籤中的內容留下，script 標籤中的內容刪除
	 * @param String content：包含 HTML 標籤的字串
	 * @return String：純文字字串
	 */
	public static String removeHtmlTag(String content){
		if(content == null) return "";
		content = content.replaceAll("(?is)\\s\\s", "");
		content = content.replaceAll("(?is)</?br>", "");
		content = content.replaceAll("(?is)<br />", "");
		content = content.replaceAll("(?is)</?p>", "");
		content = content.replaceAll("(?is)&nbsp;", "");
		content = content.replaceAll("(?is)<script/?.*?script>", "");
		content = content.replaceAll("(?is)<style/?.*?style>", "");
		content = content.replaceAll("(?is)</?[a-z][a-z0-9]*[^<>]*>","");
		content = content.replaceAll("<!--/?.*?-->", "");
		content = content.replaceAll("<!DOCTYPE /?.*?>", "");
		content = content.replaceAll("<?xml /?.*?>", "");
		content = content.replaceAll("  ", "");
		content = content.trim();
		return content;
	}
	String getUTF8String(String s) throws Exception {
		s = getString(s);
		return new String(s.getBytes("ISO-8859-1"), "UTF-8");
	}
    String getString(String s) {
        return getString(s, "");
    }
	String getString(String s, String defaultValue) {
        if (s == null)
            return defaultValue;
        return s;
    }
	String getString(String s, String defaultValue, int limit ) {
        if (s == null)
            return defaultValue;
		if( s.length()>limit )return s.substring(0,limit-1);
        return s;
    }
	int getInt(String s) {
        return getInt(s, 0);
    }
	public static int getInt(String s, int defaultValue) {
        try {
            return Integer.parseInt(s);
        } catch (Exception e) {
            return defaultValue;
        }
    }

	JspWriter out2 = null;
	void p(Object s)throws Exception{
		out2.println(s+"<br>");
	}
	void p(int s)throws Exception{
		out2.println(s+"<br>");
	}

	String plusYear(Object in){
		return plusString( in, "年" );
	}
	String plusString(Object in, String plus){
		if(in==null)return "&nbsp;";
		if(((String)in).trim().equals(""))return "&nbsp;";
		return toHtmlString(in+"") + plus;
	}
	String plusString(int in, String plus){
		if(in==0)return "&nbsp;";
		return in + plus;
	}
	String plusString( Object in, Object in2, String plus){
		String output = "&nbsp;";
		if( "&nbsp;".equals(in) || "".equals(in) )in=null;
		if( "&nbsp;".equals(in2) || "".equals(in2) )in2=null;

		if(in==null&&in2==null)output = "&nbsp;";
		else if(in!=null&&in2!=null)output = in +plus+ in2;
		else if(in!=null)output = in+"";
		else output = in2+"";

		return toHtmlString(output);
	}
	
	String easyCommand(String command,String charset)throws Exception{
           int i=0;
           Process p;
           if( command.indexOf('"')==-1 && command.indexOf('\'')==-1 ){
             //如無 ' " 視為檔名無空格，可直接執行
             p = Runtime.getRuntime().exec( command );
             i = p.waitFor();
           }else{
             //寫入指令到 sh，可防止路徑名的空白問題 
//			out2.println( i2 +" " +command+"<br>");
//             File f = new File( ebook_dir +"command_"+i2+++".sh");
             File f = File.createTempFile( "command_" , ".sh", new File(".") );

			 OutputStreamWriter osw = new OutputStreamWriter( new FileOutputStream(f), charset );

             BufferedWriter bw = new BufferedWriter( osw );
             bw.write("#/bin/bash");
             bw.newLine();

			//utf8要加才不會出錯?
			/* bw.write("export LC_ALL=\"en_US.UTF8\"");
             bw.newLine();
             bw.write("export LANG=\"en_US.UTF8\"");
             bw.newLine();
			 bw.newLine();*/

             bw.write(command);
             bw.flush();
             bw.close();
             //執行
             p = Runtime.getRuntime().exec( "sh "+ f.getAbsolutePath() );
			//out2.println( "sh "+ f.getAbsolutePath()+"<br>");
			 
             i = p.waitFor();
			f.delete();
           }
           String output = "";
           //取出訊息
           if ( i!= 0 ) {
			   /*//有的錯誤訊息在此
                   InputStream fin2 = p.getInputStream();
                   BufferedReader br2 = new BufferedReader(new InputStreamReader( fin2 ));
                   String t2;
                   while( (t2 = br2.readLine())!=null )output+=t2+"\n";//*/
					
				   //標準錯誤輸出
				   InputStream fin = p.getErrorStream();
                   BufferedReader br = new BufferedReader(new InputStreamReader( fin ));
                   String t;
                   while( (t = br.readLine())!=null )output+=t+"<br>\n";
                   throw new Exception( "指令失敗：" + output + "<br>\n\n"+command );
           }else{
                   InputStream fin2 = p.getInputStream();
                   BufferedReader br2 = new BufferedReader(new InputStreamReader( fin2 ));
                   String t;
                   while( (t = br2.readLine())!=null )output+=t+"<br>\n";
           }
		   //out2.println(output+"<br><br>");
           return output;
	}
	public boolean verify(String key){
		if("".equals(getString(key))){
			return false;
		}
		final String url = "https://www.google.com/recaptcha/api/siteverify";
		final String secret = "6Lfrcz4UAAAAAKDeZ-LdhVePMqF6BTqt4GCF3quh";
		final String USER_AGENT = "Mozilla/5.0";
		try{
			URL obj = new URL(url);
			HttpsURLConnection con = (HttpsURLConnection) obj.openConnection();
			con.setRequestMethod("POST");
			con.setRequestProperty("User-Agent", USER_AGENT);
			con.setRequestProperty("Accept-Language", "zh-TW,en;q=0.5");
			String postParams = "secret=" + secret + "&response=" + key;
			con.setDoOutput(true);
			DataOutputStream wr = new DataOutputStream(con.getOutputStream());
			wr.writeBytes(postParams);
			wr.flush();
			wr.close();
			int responseCode = con.getResponseCode();

			BufferedReader in = new BufferedReader(new InputStreamReader(
					con.getInputStream()));
			String inputLine;
			StringBuffer response = new StringBuffer();

			while ((inputLine = in.readLine()) != null) {
				response.append(inputLine);
			}
			in.close();

			// print result
			//System.out.println(response.toString());
			if(response.toString().indexOf("\"success\": true") >= 0){
				return true;
			}
			return false;
		}catch(Exception e){
			e.printStackTrace();
			return false;
		}
	}
	/*
	String getFromURL(String urlstr){
		HttpURLConnection http = null;
		String result = "";
		try{
			URL url = new URL(urlstr); 
			http = (HttpURLConnection) url.openConnection(); 
			http.setRequestMethod("GET"); 
			InputStream input = http.getInputStream(); 

			BufferedInputStream bis = new BufferedInputStream(input);
			ByteArrayBuffer baf = new ByteArrayBuffer(50);
			int read = 0;
		    int bufSize = 512;
			byte[] buffer = new byte[bufSize];
			while(true){
				read = bis.read(buffer);
				if(read==-1){
				   break;
				}
				baf.append(buffer, 0, read);
			}
			result = new String(baf.toByteArray());
			
			//byte[] data = new byte[1024]; 
			//int idx = input.read(data); 
			//String url = new String(data, 0, idx); 
			//input.close(); 

			
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			http.disconnect();
		}
		return result;
	}
	*/
%>