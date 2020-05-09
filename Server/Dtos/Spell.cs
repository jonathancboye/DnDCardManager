using System.Collections.Generic;
using System.Xml.Serialization;

namespace Server.Controllers
{
    public class Spell
    {
        [XmlElement("name")]
        public string Name { get; set; }
        [XmlElement("level")]
        public int Level { get; set; }
        [XmlElement("school")]
        public string School { get; set; }
        [XmlElement("time")]
        public string Time { get; set; }
        [XmlElement("range")]
        public string Range { get; set; }
        [XmlElement("components")]
        public string Components { get; set; }
        [XmlElement("duration")]
        public string Duration { get; set; }
        [XmlElement("classes")]
        public string Classes { get; set; }
        [XmlElement("text")]
        public List<string> Text;
        [XmlElement("roll")]
        public List<string> Roll;
    }
}
