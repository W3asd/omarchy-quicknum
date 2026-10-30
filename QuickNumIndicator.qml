import QtQuick
import qs.Commons
import qs.Commons as Commons
import qs.Ui

Rectangle {
  id: root

  property int number: 1
  property bool hasCursor: false
  property color activeTextColor: Commons.Color.menu.selectedText
  property color defaultTextColor: Commons.Color.menu.text
  property string fontFamily: Style.font.menuFamily
  property string badgeStyle: "badge" // "badge", "minimal", "subtle"

  visible: number >= 1 && number <= 9
  width: Style.space(22)
  height: Style.space(22)
  radius: Style.space(5)

  color: {
    if (badgeStyle === "minimal") return "transparent"
    if (hasCursor) return Util.alpha(activeTextColor, 0.22)
    return Util.alpha(defaultTextColor, 0.08)
  }

  border.width: badgeStyle === "minimal" ? 0 : 1
  border.color: {
    if (badgeStyle === "minimal") return "transparent"
    if (hasCursor) return Util.alpha(activeTextColor, 0.42)
    return Util.alpha(defaultTextColor, 0.14)
  }

  Text {
    anchors.centerIn: parent
    text: String(root.number)
    color: root.hasCursor ? root.activeTextColor : root.defaultTextColor
    opacity: root.hasCursor ? 1.0 : 0.76
    font.family: root.fontFamily
    font.pixelSize: Style.font.bodySmall
    font.weight: Font.DemiBold
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
  }
}

