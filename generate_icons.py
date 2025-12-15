"""
Script untuk generate launcher icons untuk Android, Windows, dan Web
dari logo_app.png

Requirement: pip install Pillow
Usage: python generate_icons.py
"""

from PIL import Image
import os

# Path ke logo
LOGO_PATH = "assets/logo_app.png"
BASE_DIR = os.path.dirname(os.path.abspath(__file__))

def generate_android_icons():
    """Generate Android launcher icons"""
    print("📱 Generating Android icons...")
    
    sizes = {
        'mipmap-mdpi': 48,
        'mipmap-hdpi': 72,
        'mipmap-xhdpi': 96,
        'mipmap-xxhdpi': 144,
        'mipmap-xxxhdpi': 192,
    }
    
    logo = Image.open(LOGO_PATH)
    
    for folder, size in sizes.items():
        # Create directory if not exists
        dir_path = os.path.join(BASE_DIR, 'android', 'app', 'src', 'main', 'res', folder)
        os.makedirs(dir_path, exist_ok=True)
        
        # Resize and save
        resized = logo.resize((size, size), Image.Resampling.LANCZOS)
        output_path = os.path.join(dir_path, 'ic_launcher.png')
        resized.save(output_path, 'PNG')
        print(f"  ✓ Created {folder}/ic_launcher.png ({size}x{size})")
    
    print("✅ Android icons generated!\n")

def generate_web_icons():
    """Generate Web icons (favicon and manifest icons)"""
    print("🌐 Generating Web icons...")
    
    logo = Image.open(LOGO_PATH)
    web_dir = os.path.join(BASE_DIR, 'web')
    
    # Favicon (multiple sizes in one file)
    favicon_sizes = [16, 32, 64]
    favicon_path = os.path.join(web_dir, 'favicon.png')
    resized = logo.resize((32, 32), Image.Resampling.LANCZOS)
    resized.save(favicon_path, 'PNG')
    print(f"  ✓ Created favicon.png (32x32)")
    
    # PWA Icons
    pwa_sizes = {
        'icons/Icon-192.png': 192,
        'icons/Icon-512.png': 512,
        'icons/Icon-maskable-192.png': 192,
        'icons/Icon-maskable-512.png': 512,
    }
    
    for path, size in pwa_sizes.items():
        full_path = os.path.join(web_dir, path)
        os.makedirs(os.path.dirname(full_path), exist_ok=True)
        
        resized = logo.resize((size, size), Image.Resampling.LANCZOS)
        resized.save(full_path, 'PNG')
        print(f"  ✓ Created {path} ({size}x{size})")
    
    print("✅ Web icons generated!\n")

def generate_windows_icons():
    """Generate Windows app icon"""
    print("🪟 Generating Windows icon...")
    
    logo = Image.open(LOGO_PATH)
    
    # Windows icon (256x256 recommended)
    windows_dir = os.path.join(BASE_DIR, 'windows', 'runner', 'resources')
    os.makedirs(windows_dir, exist_ok=True)
    
    icon_path = os.path.join(windows_dir, 'app_icon.ico')
    
    # Create ICO with multiple sizes
    sizes = [(16, 16), (32, 32), (48, 48), (64, 64), (128, 128), (256, 256)]
    images = []
    
    for size in sizes:
        resized = logo.resize(size, Image.Resampling.LANCZOS)
        images.append(resized)
    
    # Save as ICO
    images[0].save(icon_path, format='ICO', sizes=sizes)
    print(f"  ✓ Created app_icon.ico (multi-size)")
    print("✅ Windows icon generated!\n")

def main():
    print("=" * 50)
    print("🎨 Icon Generator for Flutter App")
    print("=" * 50)
    print()
    
    if not os.path.exists(LOGO_PATH):
        print(f"❌ Error: {LOGO_PATH} not found!")
        return
    
    try:
        generate_android_icons()
        generate_web_icons()
        generate_windows_icons()
        
        print("=" * 50)
        print("🎉 All icons generated successfully!")
        print("=" * 50)
        print()
        print("Next steps:")
        print("1. Android: Icons sudah di android/app/src/main/res/")
        print("2. Web: Icons sudah di web/icons/")
        print("3. Windows: Icon sudah di windows/runner/resources/")
        print()
        
    except Exception as e:
        print(f"❌ Error: {e}")
        import traceback
        traceback.print_exc()

if __name__ == '__main__':
    main()
