using UnityEngine;

namespace MyProject
{
    // ぼかし用
    public class AddBlur : MonoBehaviour
    {
        [SerializeField, Range(0, 100)] float _iteration = 10;

        // 4点サンプリング用
        [SerializeField] Shader _sampleShader = null;
        Material _sampleMaterial;

        void Start()
        {
            _sampleMaterial = new Material(_sampleShader);
        }

        void OnRenderImage(RenderTexture src, RenderTexture dest)
        {
            if (_iteration == 0)
            {
                Graphics.Blit(src, dest);
                return;
            }

            for (int i = 0; i < _iteration; i++)
            {
                RenderTexture tmpTex = RenderTexture.GetTemporary(src.width, src.height);
                Graphics.Blit(src, tmpTex);
                Graphics.Blit(tmpTex, src, _sampleMaterial);
                RenderTexture.ReleaseTemporary(tmpTex);
            }

            Graphics.Blit(src, dest);
        }
    }
}
