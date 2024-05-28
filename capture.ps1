Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms

function ScreenCapture {
  param (
    [Switch]$OfWindow
  )

  begin {
    $jpegCodec = [Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.FormatDescription -eq "JPEG" }
  }
  process {
    Start-Sleep -Milliseconds 250
  
    # Get the screen bounds
    $screenBounds = [Windows.Forms.Screen]::PrimaryScreen.Bounds
    # Write-Output "Screen bounds: $screenBounds"

    # Create a new bitmap with the size of the screen
    $bitmap = New-Object Drawing.Bitmap $screenBounds.Width, $screenBounds.Height
    # Write-Output "Bitmap size: $($bitmap.Width)x$($bitmap.Height)"

    # Create a graphics object from the bitmap
    $graphics = [Drawing.Graphics]::FromImage($bitmap)

    # Copy the screen to the bitmap
    $graphics.CopyFromScreen($screenBounds.X, $screenBounds.Y, 0, 0, $screenBounds.Size)
    # Write-Output "Copied screen to bitmap"

    # Clean up the graphics object
    $graphics.Dispose()

    # Define the quality parameter for the JPEG encoder
    $qualityParam = New-Object Drawing.Imaging.EncoderParameter ([System.Drawing.Imaging.Encoder]::Quality, [long]100)
    $encoderParams = New-Object Drawing.Imaging.EncoderParameters(1)
    $encoderParams.Param[0] = $qualityParam
    $user = $env:USERNAME
    $screenCapturePathBase = "C:\Users\$user\AppData\Local\Temp\Screencapture\ss"
    $c = (Get-Date).ToString("yyyyMMdd_HHmmss")
    $c = $c.Substring(9)
    $filePath = "${screenCapturePathBase}_${c}.jpg"

    # Save the bitmap to a file using the JPEG encoder and quality parameters
    $bitmap.Save($filePath, $jpegCodec, $encoderParams)
    # Write-Output "Saved screenshot to $filePath"

    # Clean up the bitmap object
    $bitmap.Dispose()
  }
}

# Create the directory if it doesn't exist
$user = $env:USERNAME
$screenCaptureDir = "C:\Users\$user\AppData\Local\Temp\Screencapture"
if (-not (Test-Path $screenCaptureDir)) {
    New-Item -ItemType Directory -Path $screenCaptureDir
}

while ($true) {
    Start-Sleep -Seconds 5
    ScreenCapture
}

