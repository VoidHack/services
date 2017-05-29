
import java.io.ByteArrayInputStream;
import java.io.Reader;
import java.sql.*;

public class bureaucracy
{
	private static String url = "jdbc:mysql://127.0.0.1/bureaucracy";
	
	public static void main(String[] args)
	{
		try {
			Class.forName ("com.mysql.jdbc.Driver").newInstance();
			Connection conn = DriverManager.getConnection(url, "bureaucracy", "8932ruhfjeu8ergkdgh");
			if (args.length<1)
			{
				System.out.println("no args");
				return;
			}
			if (args[0].equals("get"))
			{
				PreparedStatement stGet = conn.prepareStatement("INSERT INTO flags VALUES(?,?,?,?)");
				for (int i=1; i<3; ++i)
					stGet.setString(i, args[i]);
				stGet.setString(4, args[4]);
				byte [] x = Base64.decode(args[3]);
				stGet.setBinaryStream(3, new ByteArrayInputStream(x), x.length );
				stGet.executeUpdate();
				System.out.println("get");
			}
			if (args[0].equals("put"))
			{
				PreparedStatement stPut = conn.prepareStatement("SELECT previd, data, ch FROM flags WHERE id=?");
				stPut.setString(1, args[1]);
				ResultSet res = stPut.executeQuery();
				if (!res.next())
					return;
				Reader r = res.getCharacterStream(2);
				System.out.print(res.getString(1) + "=");
				char []bin = new char[256];
				int num = r.read(bin, 0, 256);
				for (int i=0; i<num; ++i)
					System.out.print(bin[i]);
				System.out.println("=" + res.getString(3));
			}
			conn.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
