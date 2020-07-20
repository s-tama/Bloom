using UnityEngine;

namespace MyProject
{
    // 輝度抽出用
    public class Bloom : MonoBehaviour
    {
        readonly int ShaderPropertyIDThreshold = Shader.PropertyToID("_Threshold");

        [SerializeField, Range(0, 100)] float _iteration = 10;
        [SerializeField, Range(0, 1)] float _threshold = 1f;

        // 4点サンプリング用
        [SerializeField] Shader _sampleShader = null;
        Material _sampleMaterial;

        // ブレンド用
        [SerializeField] Shader _blendShader = null;
        Material _blendMaterial;

        void Start()
        {
            _sampleMaterial = new Material(_sampleShader);
            _blendMaterial = new Material(_blendShader);
        }

        void OnRenderImage(RenderTexture src, RenderTexture dest)
        {
            if (_iteration == 0)
            {
                Graphics.Blit(src, dest);
                return;
            }

            RenderTexture defaultTex = new RenderTexture(src.width, src.height, 0, src.format);
            Graphics.Blit(src, defaultTex);

            _sampleMaterial.SetFloat(ShaderPropertyIDThreshold, _threshold);

            for (int i = 0; i < _iteration; i++)
            {
                RenderTexture tmpTex = RenderTexture.GetTemporary(src.width, src.height);
                Graphics.Blit(src, tmpTex);
                Graphics.Blit(tmpTex, src, _sampleMaterial);
                RenderTexture.ReleaseTemporary(tmpTex);
            }

            _blendMaterial.SetTexture("_BlendTex", defaultTex);
            Graphics.Blit(src, dest, _blendMaterial);
        }
    }
}
