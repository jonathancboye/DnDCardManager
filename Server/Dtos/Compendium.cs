using System.Collections.Generic;
using System.Xml.Serialization;
using System.IO;

namespace Server.Controllers
{
    [XmlRoot(ElementName = "compendium")]
    public class Compendium
    {
        [XmlElement("spell")]
        public List<Spell> Spells { get; set; }

        public static Compendium Load(string filename)
        {
            using (FileStream stream = File.OpenRead(filename))
            {
                XmlSerializer searlizer = new XmlSerializer(typeof(Compendium));
                return (Compendium)searlizer.Deserialize(stream);
            }
        }
    }
}
