angleConversions = require("angleConversions")
require("ecef2lla")
require("lla2ecef")
require("ReferenceLatLongAlt")

lastPositionX = 0
lastPositionY = 0
lastPositionZ = 0

function convertPositionFromHLA()

--convert orientation
latTemp, lonTemp, discard = ecef2lla(DSimLocal.WorldLocation.X,DSimLocal.WorldLocation.Y,DSimLocal.WorldLocation.Z)

local lat = math.rad(latTemp)  --converting to rad because function requires rad
local lon = math.rad(lonTemp)

local psi =  DSimLocal.Orientation.Psi-- roll
local theta = DSimLocal.Orientation.Theta--pitch
local phi = DSimLocal.Orientation.Phi --yaw

DSimLocal.Orientation.Psi =  angleConversions.getOrientationFromEuler(lat, lon, psi, theta)
DSimLocal.Orientation.Theta = angleConversions.getPitchFromEuler(lat, lon, psi, theta)
DSimLocal.Orientation.Phi = angleConversions.getRollFromEuler(lat, lon, psi, theta, phi)


--- convert position


lastPositionX = DSimLocal.WorldLocation.X
lastPositionY = DSimLocal.WorldLocation.Y
lastPositionZ = DSimLocal.WorldLocation.Z

-- Since we are working over a fairly small part of the planet, we can assume a flat surface
--convert lat/long to geocentric
tempx, tempy, tempz = lla2ecef(referenceOffset_Lat , referenceOffset_Long , referenceOffset_Alt )

-- Data we are receving is already geocentric
-- * 100 convert units from meters to cm

DSimLocal.WorldLocation.X = (DSimLocal.WorldLocation.X - tempx)
DSimLocal.WorldLocation.Y = (DSimLocal.WorldLocation.Y - tempy)
DSimLocal.WorldLocation.Z = (DSimLocal.WorldLocation.Z - tempz)

end